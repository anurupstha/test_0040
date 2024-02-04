terraform {
    required_providers {
        aws = {
        source = "hashicorp/aws"
        version = ">= 3.0.0"
        }
    }

}

#  Configure the AWS Provider
provider "aws" {
  region = "us-east-1"   
}
# Deploy EC2 instance with key pair with server

resource "aws_instance" "myec2" {
  ami = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  key_name = "terraform"
  vpc_security_group_ids = [ "sg-0c2ac51aa7d6f3522" ]
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y apache2
              echo '<h1>Hello, World!</h1>' | sudo tee /var/www/html/index.html
              EOF
  tags = {
    Name = "myec2"
  }
}
#Terraform state locking using DynamoDB and S3 bucket

terraform {
  backend "s3" {
    bucket = "terraform-state-github-actions"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-locking-github"
  }
}
