
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.7.3"

  name                    = "project_2"
  cidr                    = "10.0.0.0/16"
  map_public_ip_on_launch = true


  azs            = ["eu-west-2a"]
  public_subnets = ["10.0.0.0/24"]


  tags = {
    Name = "project_2_vpc"
  }
}