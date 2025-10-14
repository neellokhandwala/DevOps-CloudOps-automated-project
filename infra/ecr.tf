resource "aws_ecr_repository" "project_ecr" {
  name = "project-ecr-repo"
}

resource "aws_ecr_lifecycle_policy" "project_ecr_lifecycle" {
  repository = aws_ecr_repository.project_ecr.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire untagged images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": { "type": "expire" }
        }
    ]
}
EOF
}
