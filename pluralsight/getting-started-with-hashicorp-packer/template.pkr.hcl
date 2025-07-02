data "amazon-ami" "globoticket" {
  filters = {
    name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  /* As long as the most_recent field is set to true, the data source will always find the most recently built copy of the AMI that 
    matches all of your other criteria.
    */
  most_recent = true
  /* In this data source, the owners field contains the official account number of the Ubuntu account, which can be accessed via 
    their website or AWS console.
    */
  owners = ["099720109477"]
}

data "amazon-secretsmanager" "globoticket-live" {
  name = "Globolticket-live"
  key  = "SECRET_ARTIST_NAME"
}

# Source blocks configure specific builder plugins, which are subsequently invoked by build blocks.
source "amzon-ebs" "globoticket" {
  /* In HCL2, you may call numerous functions from within a string using this ${ syntax. They refer to this as a template sequence.
    In this case, we are generating a unique identifier string for ourselves by calling the function uuidv4, which takes the output
    of whatever is within the curly braces and inserts it into that position in the string.
    */
  ami_name      = "globoticket-${uuidv4()}"
  instance_type = "t3.micro"
  #source_ami = "ami-0c262369dcdfc38a8"
  # A dot-separated string whose value is the class of the data.resource type.resource name.
  source_ami   = "data.amazon-ebs.globoticket.id"
  ssh_username = "ubuntu"
}

source "virtualbox-iso" "globoticket" {
  guest_os_type = "Unbuntu_64"
  # Displays the VirtualBox console and allows you to view the Packer build process.
  headless = false
  iso_url  = "https://releases.ubuntu.com/noble/ubuntu-24.04.2-live-server-amd64.iso"
  # Packer will not proceed if the checksum is incorrect for the ISO source.
  iso_checksum           = "d6dab0c3a657988501b4bd76f1297c053df710e06e0c3aece60dead24f270b4d"
  ssh_username           = "vagrant"
  ssh_password           = "vagrant"
  ssh_handshake_attempts = 20
  ssh_timeout            = "30m"
  /* The http data source performs an HTTP GET request to the given URL and exports the response information. In this case the 
    directory holds the Cloudinit configuration file required for the Ubuntu installation.
    */
  http_directory = "http"
  cpus           = 3
  memory         = 8192
  # Forces Packer to wait for the Ubuntu ISO to load.
  boot_wait = "5s"
  boot_command = [
    "<enter><enter><f6><esc><wait>",
    "autoinstall ds-nocloud-net;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<enter><wait>"
  ]
  /* Packer runs vboxmanage, a command-line interface for configuring Virtualbox. Using this command, we instruct Virtualbox to
    use a specific graphics controller and to increase the amount of VRAM from the default.
    */
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--graphicscontroller", "vmsvga"],
    ["modifyvm", "{{.Name}}", "--vram", "32"]
  ]
}

# After Packer has been launched, the build block specifies what should be done.
build {
  # The source consists of a dot-separated string containing the class of the resource.type of the resource.name of the resource.
  sources = ["source.amazon-ebs.globoticket", "source.virtualbox-iso.globoticket"]
  /* The provisioner handles the meat of the infrastructure setup. It is the portion of your infrastructure 
    that enables you to customize your image, making sure that your application is deployed in an immutable 
    state with everything it requires.
    */
  provisioner "file" {
    destination = "/tmp"
    source      = "globoticket_assetes"
  }
  provisioner "file" {
    destination = "/tmp"
    source      = "config/nginx.service"
  }
  provisioner "file" {
    destination = "/tmp"
    source      = "config/nginx.conf"
  }
  provisioner "shell" {
    /* First, make sure we are running as the root user, since we will be copying data to some sensitive areas. Second Packer 
        maintains two variables when working in a provisioner, Vars, containing all the environment variables that Packer needs 
        to pass the command, including any environment variables that you specify as part of the provisioner, and Path, containing 
        a path to the script Packer will run, which is automatically populated.s
        */
    execute_command = "sudo -S env {{ .Vars }} {{ .Path}}"
    /* Here we have the inline field, which allows us to specify our script commands in the form of an array of strings, each 
        containing one command.
        */
    inline = [
      "mkdir -p /var/globoticket",
      "mv /tmp/nginx.conf /var/globoticket",
      "mv /tmp/nginx.service /etc/systemd/system/nginx.service",
      "mv /tmp/globoticket_assets/** /var/globoticket"
    ]
  }
  provisioner "shell" {
    execute_command  = "sudo -S env {{ .Vars }} {{ .Path }}"
    environment_vars = ["SECRET_ARTIST_NAME=${data.amazon-secretsmanager.globoticket-live.value}"]
    /* The script field refers to a script running on your host machine, which Packer transparently uploads, runs, and cleans up 
        at the end of the process.
        */
    script = "scripts/build_nginx_webap.sh"
    only   = ["amazon-ebs.globoticket"]
  }
  provisioner "shell" {
    execute_command = "sudo -S env {{ .Vars }} {{ .Path }}"
    script          = "scripts/build_nginx_webap.sh"
    only            = ["virtualbox-iso.globoticket"]
  }
  provisioner "shell" {
    execute_command = "sudo -S env {{ .Vars }} {{ .Path }}"
    script          = "scripts/virtualbox.sh"
    only            = ["virtualbox-iso.globoticket"]
  }
  provisioner "shell" {
    execute_command = "sudo -S env {{ .Vars }} {{ .Path }}"
    script          = "scripts/vagrant.sh"
    only            = ["virtualbox-iso.globoticket"]
  }

  # Post-processors allow you to modify Packers output images.
  post-procesor "vagrant" {
    # It is possible to set keep input artifact to true in order to maintain the original OVA.`-`
    # keep_input_artifact = true
    only = ["virtualbox-iso.globoticket"]
  }
}