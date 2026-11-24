resource "aws_iam_role" "project-2-ec2-role" {
  name = "project-2-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name    = "EC2-Role"
    Project = "Project-2"
  }
}


resource "aws_iam_role_policy_attachment" "ec2_attach" {
  role       = aws_iam_role.project-2-ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_role_policy_attachment" "ecr_attach" {
  role       = aws_iam_role.project-2-ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-Project-2"
  role = aws_iam_role.project-2-ec2-role.name
}