
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.7.3"

  name                    = "project_1"
  cidr                    = "10.0.0.0/16"
  map_public_ip_on_launch = true


  azs             = ["eu-west-2a"]
  private_subnets = ["10.0.2.0/24"]
  public_subnets  = ["10.0.0.0/24"]


  tags = {
    Name = "project_1_vpc"
  }
}
