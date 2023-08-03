# Push images to ecr with github actions
## About
This repo is a demo for building image and push image to ECR with github action.

![architect.png](https://github.com/jianxing31/gitHub-action-push-image-to-ecr/blob/master/images/architect.png)

In this demo, Github action will assume a IAM role to get the permission of pushing docker images to ECR. There are other ways to assume IAM role, like using aws credentials or using eks-hosted action runners.

## Getting Started
### 1. set up environments
- set up aws environment variables
```shell
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_DEFAULT_REGION=us-west-2
```
- Set up the values in variables.tf  
You need to replace var.allowed_github_repos with your repo name.

### 2. Deploy the resources in this repo

- Install all providers
```shell
terraform init
```
- Apply these resources
```shell
terraform apply
```

### 3. Build a workflow to build images and push images to ECR
Example workflow:
```shell
name: image-build-and-push
on:
  push:
    branches:
      - my-branch
    paths:
        - '**'
permissions:
  id-token: write
  contents: read

jobs:
  build:
    name: Build Image
    runs-on: ubuntu-latest
    steps:
      - name: Check out code
        uses: actions/checkout@v2
      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v1.7.0
        with:
          role-to-assume: ENTER YOUR ROLE ARN HERE
          aws-region: us-east-1
      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1
      - name: Build, tag, and push image to Amazon ECR
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          ECR_REPOSITORY: github_action_repository
          IMAGE_TAG: ${{ github.sha }}
        run: |
          cd security-sandbox/ecr
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
```

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.3.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.6.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.6.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [aws_ecr_repository.github_action](https://registry.terraform.io/providers/hashicorp/aws/5.6.0/docs/resources/ecr_repository) | resource |
| [aws_iam_openid_connect_provider.github_actions](https://registry.terraform.io/providers/hashicorp/aws/5.6.0/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.github_actions](https://registry.terraform.io/providers/hashicorp/aws/5.6.0/docs/resources/iam_role) | resource |
| [aws_iam_policy_document.ecr_push](https://registry.terraform.io/providers/hashicorp/aws/5.6.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.github_actions](https://registry.terraform.io/providers/hashicorp/aws/5.6.0/docs/data-sources/iam_policy_document) | data source |
| [tls_certificate.github_actions](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_github_repos"></a> [allowed\_github\_repos](#input\_allowed\_github\_repos) | Allowed github repos. Need to replace this value with your repos | `list(any)` | n/a | yes |
| <a name="input_ecr_repo_name"></a> [ecr\_repo\_name](#input\_ecr\_repo\_name) | Ecr repo name that will be created | `string` | `"github_action_repository"` | no |
| <a name="input_github_action_iam_name"></a> [github\_action\_iam\_name](#input\_github\_action\_iam\_name) | IAM role name that github action can assume | `string` | `"github-actions-role"` | no |

### Outputs

No outputs.
<!-- END_TF_DOCS -->

## Reference
[GitHub ActionsでOIDCによるAWS認証をTerraformで実装する](https://zenn.dev/nameless_gyoza/articles/github-actions-aws-oidc-by-terraform)
