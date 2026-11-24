resource "aws_instance" "app_server" {
  ami                         = "ami-05ae078e92a0884dd"
  instance_type               = "t3.micro"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.project_2_sg.id]
  user_data                   = file("${path.module}/user_data.sh")
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  user_data_replace_on_change = true
  monitoring                  = false
  tags = {
    Name = "project_2_app_server"
  }
  lifecycle {
    ignore_changes = [user_data]
  }
}


output "public_ip" {
  description = "EC2 instance's public IPv4 address"
  value       = aws_instance.app_server.public_ip
}
