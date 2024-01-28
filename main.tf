terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
     
  }
}  
provider "aws" {
    region = "us-east-1"
  
}
data "aws_ami" "alami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}
variable "key_name" {
  type = string
  default = "<your-key>"
  
}
resource "aws_instance" "prj" {
    ami           = data.aws_ami.alami.id
    instance_type = "t2.micro"
    key_name = var.key_name
    user_data = templatefile("${abspath(path.module)}/master.sh")
  
}
