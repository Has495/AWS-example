resource "aws_iam_policy" "ssm_policy" {
  name        = "github-actions-ssm-policy"
  description = "Allows GitHub Actions to send deployment commands to my EC2 instance"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [

      {
        Sid    = "SendCommandPermissions"
        Effect = "Allow"

        Action = [
          "ssm:SendCommand"
        ]

        Resource = [
          aws_instance.app_server.arn,
          "arn:aws:ssm:eu-west-2::document/AWS-RunShellScript"

        ]
      },

      {
        Sid    = "CommandStatusPermissions"
        Effect = "Allow"

        Action = [
          "ssm:GetCommandInvocation",
          "ssm:ListCommandInvocations"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.project_2_github_role.name
  policy_arn = aws_iam_policy.ssm_policy.arn
}