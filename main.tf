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
# Deploy Windows Server 2022 EC2 instance
resource "aws_instance" "windows_instance" {
  ami = "ami-00d990e7e5ece7974" # replace with your Windows Server 2022 AMI ID
  instance_type = "t2.micro"
  key_name = "terraform"
  vpc_security_group_ids = [ "sg-0c2ac51aa7d6f3522" ]
  user_data = <<-EOF
              <powershell>
              Install-WindowsFeature -name Web-Server -IncludeManagementTools
              New-Item -Path 'C:\inetpub\wwwroot' -ItemType Directory -Force
              Add-Content -Path 'C:\inetpub\wwwroot\index.html' -Value '<h1>Hello, Windows World!</h1>'
              </powershell>
              EOF
  tags = {
    Name = "WindowsInstance"
  }
}

#Create S3 bucket

resource "aws_s3_bucket" "mybucket-anurup1" {
  bucket = "mybucket-anurup1"
  tags = {
    Name = "mybucket-anurup1"
  }
}  

# Create EBS volume

resource "aws_ebs_volume" "myebs" {
  availability_zone = "us-east-1a"
  size = 10
  tags = {
    Name = "myebs"
  }
}

# Create EBS volume attachment

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id = aws_ebs_volume.myebs.id
  instance_id = aws_instance.myec2.id
  force_detach = true
}