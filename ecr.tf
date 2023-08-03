resource "aws_ecr_repository" "github_action" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = {
    Environment = "Dev"
    Service     = "Infra"
  }
}
