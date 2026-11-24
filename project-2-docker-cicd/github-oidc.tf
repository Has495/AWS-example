
resource "aws_iam_openid_connect_provider" "project2" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]
}

resource "aws_iam_role" "project_2_github_role" {
  name = "project-2-github-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"

        Principal = {
          Federated = aws_iam_openid_connect_provider.project2.arn
        }

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:Has495/AWS-example:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "github-actions-ecr-policy"
  description = "Allows GitHub Actions to push Docker images to ECR"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid      = "ECRAuthorization"
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      {
        Sid    = "ECRPushPermissions"
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]

        Resource = aws_ecr_repository.project-2-webserver.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  role       = aws_iam_role.project_2_github_role.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}
