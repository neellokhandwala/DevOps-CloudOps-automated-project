resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "ECS_CPU_High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  threshold           = 70
  period              = 300
  alarm_description   = "High CPU on ECS Service"

  dimensions = {
    ClusterName = aws_ecs_cluster.project_ecs.name
    ServiceName = aws_ecs_service.project_ecs_service.name
  }
}
