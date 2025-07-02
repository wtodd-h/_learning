/* 
  ----------------------
  - PACKER PLUGIN BLOCK
  - A list of external plugins that the template requires is included in this block.
  ----------------------
*/
packer {
  required_plugins {
    vsphere = {
      version = "" # The version attribute is optional, but Hashicorp recommends using it.
      source  = "" # The source attribute is only necesssary when requiring a plugin outside the HashiCorp domain.
    }
  }
}

/* 
  ---------------------
  - DATA BLOCK
  - The data block instructs Packer to read from a given data source and export the result under a given local name.
  ----------------------
*/
data "hcp-packer-version" "hardened-source" {
  bucket_name  = "hardened-ubuntu-16-04"
  channel_name = "dev"
}

/*
  ----------------------
  - LOCAL VARIABLE BLOCK
  - Locals are defined within the Packer configuration by the locals block, also known as the local-variable block.
  ----------------------
*/
locals {
  ice_cream_flavor = "${var.flavor}-ice-cream"
  foo              = "bar"
}

/*
  ----------------------
  - INPUT-VARIABLE BLOCK
  - The variable block, or input-variable block, defines variables within your Packer configuration.
  ----------------------
*/
variable "flavor" {
  type        = string
  default     = "strawberry"
  description = ""
}

/*
  ----------------------
  - SOURCE BLOCK
  - Source blocks configure specific builder plugins, which are subsequently invoked by build blocks.
  ----------------------
*/
source "type" "name" {

}

/*
  ----------------------
  - BUILD BLOCK
  - Build blocks define what builders should be started, how to provision them, and if necessary, what to do with their artifacts 
    through post-processing.
  ----------------------
*/
build {
  # The source consists of a dot-separated string containing the class of the resource.type of the resource.name of the resource.
  sources = ["source.type.name"]
  /* The provisioner handles the meat of the infrastructure setup. It is the portion of your infrastructure 
    that enables you to customize your image, making sure that your application is deployed in an immutable 
    state with everything it requires.
    */
  provisioner "type" {

  }
/*
  ----------------------
  - POST-PROCESSOR BLOCK
  - Post-processors allow you to modify Packers output images.
  ----------------------
*/
  post-procesor "type" {

  }
}