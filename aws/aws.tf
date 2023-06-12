provider "aws" {
  region = "us-east-1"
}
terraform {
  required_version = "= 1.0.5"
}
resource "aws_instance" "k0s" {
  count = 2
  ami = "ami-0261755bbcb8c4a84" 
  instance_type = "t2.micro"
  vpc_security_group_ids = ["launch-wizard-1"]
  key_name = "ks511"
  tags = {
  Name = "k0s-${count.index}"
  }
}
output "instance_ips" {
  value = aws_instance.k0s.*.public_ip
}
