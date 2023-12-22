/*--------------- AMI ids ---------------*/

data "aws_ami" "ubuntu" {

  most_recent = true
  # ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20231025
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"]
}

output "image-id" {
  value       = data.aws_ami.ubuntu.id
  description = "Ubuntu AMI id"
}
