data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_subnet" "selected" {
  id = var.subnet_id
}

data "aws_key_pair" "linux_pem" {
  key_name           = "linux_pem"
  include_public_key = true
}

data "aws_security_groups" "selected" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_instance" "sandbox" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = data.aws_key_pair.linux_pem.key_name
  vpc_security_group_ids      = data.aws_security_groups.selected.ids

  root_block_device {
    volume_type = "gp3"
    volume_size = 30
  }
}
