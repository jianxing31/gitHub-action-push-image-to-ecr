# ref: https://zenn.dev/nameless_gyoza/articles/github-actions-aws-oidc-by-terraform
resource "aws_iam_role" "github_actions" {
  name               = var.github_action_iam_name
  assume_role_policy = data.aws_iam_policy_document.github_actions.json
  inline_policy {
    name   = "github-actions-ecr-policy"
    policy = data.aws_iam_policy_document.ecr_push.json
  }
  description = "IAM Role for GitHub Actions OIDC"
}

data "aws_iam_policy_document" "github_actions" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.github_actions.arn
      ]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = var.allowed_github_repos
    }
  }
}
data "aws_iam_policy_document" "ecr_push" {
  statement {
    sid = "AllowEcrPush"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:TagResource",
      "ecr:ListTagsForResource"
    ]
    resources = [
      "arn:aws:ecr:*:*:repository/${var.ecr_repo_name}",
    ]
  }
  statement {
    sid       = "AllowEcrToken"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
}
