resource "aws_ecr_repository" "project-2-webserver" {
  name                 = "project-2-webserver"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}