resource "aws_ecs_cluster" "project_ecs" {
  name = "project-ecs-cluster"
}

resource "aws_cloudwatch_log_group" "project_log_group" {
  name              = "project-log-group"
  retention_in_days = 7
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "project_ecs_task" {
  family                   = "project-ecs-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "app",
      image = "${aws_ecr_repository.project_ecr.repository_url}:latest",
      portMappings = [{ containerPort = 8080, protocol = "tcp" }],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.project_log_group.name,
          awslogs-region        = "ap-south-1",
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "project_ecs_service" {
  name            = "project-ecs-service"
  cluster         = aws_ecs_cluster.project_ecs.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.project_ecs_task.arn
  desired_count   = 2

  network_configuration {
    subnets          = ["subnet-0f1986ea60dcd4b2e", "subnet-02204c65881436aa7"]
    assign_public_ip = true
    security_groups  = [aws_security_group.project_sg.id]
  }
}
