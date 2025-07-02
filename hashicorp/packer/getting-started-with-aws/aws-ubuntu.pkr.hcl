/*  
    .DESCRIPTION
    With Packer installed, it is time to build your first image. In this tutorial, you will build a t2.micro Amazon EC2 AMI. This tutorial will
    provision resources that qualify under the AWS free-tier. If your account doesn't qualify under the  AWS free-tier, we're not responsible
    for any charges that you may incur.
/*

/*
  ----------------------
  - PACKER PLUGIN BLOCK
  - A list of external plugins that the template requires is included in this block.
  ----------------------
*/
packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.6"                    # The version attribute is optional, but Hashicorp recommends using it.
      source  = "github.com/hashicorp/amazon" # The source attribute is only necesssary when requiring a plugin outside the HashiCorp domain.
    }
  }
}

/*
  ----------------------
  - SOURCE BLOCK
  - Source blocks configure specific builder plugins, which are subsequently invoked by build blocks.
  ----------------------
*/
source "amazon-ebs" "ubuntu" {
  ami_name      = "learn-packer-linux-aws"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

/*
  ----------------------
  - BUILD BLOCK
  - Build blocks define what builders should be started, how to provision them, and if necessary, what to do with their artifacts 
    through post-processing.
  ----------------------
*/
build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install nginx -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
      "sudo ufw allow proto tcp from any to any port 22,80,443",
      "echo 'y' | sudo ufw enabled"
    ]
  }

/*
  ----------------------
  - POST-PROCESSOR BLOCK
  - Post-processors allow you to modify Packers output images.
  ----------------------
*/
  post-processor "vagrant" {

  }
  post-processor "compress" {

  }
}