resource "aws_security_group" "project_sg" {
  name        = "project-ecs-sg"
  description = "Security group for ECS Fargate service"
  vpc_id      = "vpc-00615de11e6b01e45"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "project-ecs-sg" }
}
