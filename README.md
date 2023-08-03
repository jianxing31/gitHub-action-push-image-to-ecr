# Push images to ecr with github actions
## About
This repo is a demo for building image and push image to ECR with github action.
![architect.png](https://github.com/jianxing31/gitHub-action-push-image-to-ecr/blob/master/images/architect.png)
In this demo, Github action will assume a IAM role to get the permission of pushing to ECR. There are other ways to assume IAM role, like using aws credentials or using eks-hosted action runners(I prefer this way in prod.)

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

### 3. Build a workflow to build image and push image to ECR
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
<!-- END_TF_DOCS -->

## Reference
[GitHub ActionsでOIDCによるAWS認証をTerraformで実装する](https://zenn.dev/nameless_gyoza/articles/github-actions-aws-oidc-by-terraform)
