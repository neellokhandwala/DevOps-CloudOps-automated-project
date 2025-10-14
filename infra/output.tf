output "ecr_repository_url" {
  value = aws_ecr_repository.project_ecr.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.project_ecs.name
}
