variable "github_action_iam_name" {
  default     = "github-actions-role"
  type        = string
  description = "IAM role name that github action can assume"
}

variable "allowed_github_repos" {
  #default = ["repo:jianxing31/gitHub-action-push-image-to-ecr:*"]
  type        = list(any)
  description = "Allowed github repos. Need to replace this value with your repos"
}

variable "ecr_repo_name" {
  default     = "github_action_repository"
  type        = string
  description = "Ecr repo name that will be created"
}
