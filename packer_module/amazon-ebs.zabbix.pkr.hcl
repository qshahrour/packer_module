#=> Defining Plugins
packer {
  required_plugins {
    amazon = {
      version = "~> 1.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
######################################
###################################
## 	=> 	Defining Variables
###################################
variable "profile" {
  type      = string
  default   = "ingot"
}

variable "vpc_id" {
  type      = string
  default   = "current"
  #default       ="vpc-0d924ecc9c8e05b86"
}

variable "region" {
  description   ="The AWS region you're using"
  type          =string
  default       = "eu-central-1"
}

variable "subnet_id" {
  description   ="The Subnet to build the AMI inm that's ssh'able"
  type          =string
  default   = "current"
  //default       ="subnet-05f8f3c120238ca8d"
}

variable "ami_id" {
  type      = string
  default   = "ami-04dfd853d88e818e8"
}

variable "BUILD_NUMBER" {
  description="The build number"
  type          =string
  default       ="1"
}

variable "instance_standard" {
  default       ="r5dn.large"
  description   ="The AMI build instance"
  type          =string
}

variable "instance_ultimate" {
  default       ="r5dn.xlarge"
  description   ="The AMI build instance"
  type          =string
}

variable "ami_users" {
  default=[]
}

variable "associate_public_ip_address" {
  type          = bool
  default       = true
}

variable "ssh_interface" {
  type          = string
  default       = "public_ip"
}


variable "APP_NAME" {
  default = "Zabbix"
}

variable "APP_NAME_1FT" {
  type      = string
  default   = "Zabbix1"
}

variable "APP_NAME_2ND" {
  type      = string
  default   = "Zabbix2"
}

variable "ami_prefix" {
  type      = string
  default   = "ubuntu base 22.04"
}

variable "source_path" {
  type      = string
  default   = "./"
}

variable "amazon-ami" {
  default   = "current"
}

variable "standardCPUCredit" {
  default   = []
}

variable "ssh_user" {
  type      = string
  default   = "ubuntu"
}

variable  "AWS_DEFAULT_REGION" {
  default = "eu-central-1"
}

variable "unlimitedCPUCredit" {
  default     = []
}

variable "script_path" {
  default   = env("SCRIPT_PATH")
}
#locals {
#  image_options         = var.images[var.image]
#  image_name            = "${basename(path.cwd)}/${var.image}"
#  image_description     = local.image_options.core.image_description
#  image_version         = "${local.image_options.core.image_version}.${var.version}"
#  image_provider        = var.provider
#  image_build           = var.build
#  artifacts_directory   = "${path.cwd}/../../artifacts/${local.image_name}/${local.image_provider}/${var.build}"
#}

locals {
  app_name            = "Zabbix"
  root                = path.root
  scripts_folder      = "${path.root}/scripts"
  settings_file       = "${path.cwd}/settings.txt"
  ami_name            = "${var.APP_NAME}-prodcution"
  timestamp           = "${formatdate("YYYYMMDD'-'hhmmss", timestamp())}"
  creation_date       = "${formatdate("YYYY-MM-DD-hhmm", timestamp())}"
  build               = "$(curl http://169.254.169.254/latest/meta-data/ami-id)"
}

########################################
# => Writing our Sources
source "amazon-ebs" "Zabbix1" {
  #name                = "packer-build-${var.APP_NAME}"
  #output              = "AWS AMI"
  ami_description     = "amazon ubuntu AMI"
  ami_name            = "${var.ami_prefix}-${local.timestamp}"
  instance_type       = "${var.instance_standard}"
  region              = "${var.region}"
  source_ami          = "${var.ami_id}"
  #spot_instance_types       = ["t3.xlarge"]
  #enable_unlimited_credits  = true
  ssh_username              = "${var.ssh_user}"
  ssh_agent_auth            = false
  ssh_timeout               = "30m"
  ssh_wait_timeout          = "10000s"
  #skip_create_ami           = true
  ebs_optimized                   = true
  associate_public_ip_address     = var.associate_public_ip_address

  tags = {
    Name          = "ubuntu-base-packer"
    OS_Version    = "Ubuntu 22.10"
  }

  spot_price                  = "auto"
  ssh_interface               = var.ssh_interface
  //subnet_id                   = var.subnet_id
  temporary_key_pair_name     = "amazon-packer-{{timestamp}}"
  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 100
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = false
  }
  source_ami_filter {
    filters = {
      name                  = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type      = "ebs"
      virtualization-type   = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
}
################################################################################
################################################################################

source "amazon-ebs" "Zabbix2" {
  #name                = "packer-build-${APP_NAME_2ND}"
  #output              = "AWS AMI"
  ami_description     = "amazon ubuntu AMI"
  ami_name            = "${var.ami_prefix}-${local.timestamp}"
  instance_type       = "${var.instance_ultimate}"
  region              = "${var.region}"
  source_ami          = "${var.ami_id}"
  #spot_instance_types       = ["t3.xlarge"]
  #enable_unlimited_credits  = true
  ssh_username              = "${var.ssh_user}"
  ssh_agent_auth            = false
  ssh_timeout               = "30m"
  ssh_wait_timeout          = "10000s"
  #skip_create_ami           = true
  ebs_optimized                   = true
  associate_public_ip_address     = var.associate_public_ip_address

  tags = {
    Name          = "ubuntu-base-packer"
  }

  spot_price                  = "auto"
  ssh_interface               = var.ssh_interface
  //subnet_id                   = var.subnet_id
  temporary_key_pair_name     = "amazon-packer-{{timestamp}}"
  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 100
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = false
  }
  source_ami_filter {
    filters = {
      name                  = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type      = "ebs"
      virtualization-type   = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
}

######################################################################################
######################################################################################

build {

sources = [
  "source.amazon-ebs.Zabbix1",
  "source.amazon-ebs.Zabbix2"
  ]

  #provisioner "shell" {
  #  execute_command = [" ${local.creation_date}"]
  #}

  provisioner "file" {
    source      = "./tf-packer.pub"
    destination = "/tmp/tf-packer.pub"
  }
  provisioner "shell" {
    environment_vars = [
      "HOME_DIR=/home/ubuntu"
    ]
    script = "scripts/update.sh"
    #pause_before = "10s"
    #max_retries = 5
    #timeout = "5m"
  }

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt install --yes -qq ca-certificates curl",
      "sudo apt autoclean",
      "sudo apt-get update -y",
    ]
    pause_before = "10s"
    max_retries = 5
    timeout = "5m"
  }

  #provisioner "shell" {
  #  execute_command = ["echo ${local.timestamp}Runnning Docker Installation Script"]
  #}

  provisioner "shell" {
    environment_vars = [
      "HOME_DIR=/home/ubuntu"
    ]
    execute_command   = "{{.Vars}} sudo -S -E bash -eux '{{.Path}}'"
    expect_disconnect = true
    script = "./scripts/install-docker.sh"
  }

  post-processor "shell-local" {
    inline = ["echo \"Hello World from ${source.type}.${source.name}\""]
  }

  provisioner "shell" {
    inline    = ["sudo usermod -aG docker ubuntu"]
  }

  provisioner "shell" {
    environment_vars = [
      "HOME_DIR=/home/ubuntu"
    ]
    execute_command   = "{{.Vars}} sudo -S -E bash -eux '{{.Path}}'"
    expect_disconnect = true
    script = "./scripts/install-compose.sh"
  }

  #post-processor "shell-local" {
  #  command    = ["docker-compose --version && docker --version"]
  #}

  provisioner "shell" {
    only = ["amazon-ebs.Zabbix2"]
    inline = [ "aws configure set region ${var.region} --profile ${var.profile}"]
  }

  //provisioner "shell" {
  //  environment_vars = ["HELLO_USER=packeruser", "UUID=${build.PackerRunUUID}", "HOME_DIR=/home/ubuntu"]
  //  execute_command   = "{{.Vars}} sudo -S -E bash -eux '{{.Path}}'"
  //  #expect_disconnect = true
  //  script = "./scripts/install_powershell.sh"
  //}

  ## This provisioner only runs for the 'first-example' source.
  provisioner "shell" {
    inline = [
      "aws configure set region ${var.region} --profile default"
    ]
  }

  provisioner "file" {
    #source              = fileset(path.cwd, "docker-compose.yaml")
    source              = "./docker-compose.yaml"
    destination         = "/home/${var.ssh_user}/docker-compose.yaml"
  }

  post-processor "shell-local" {
    inline = ["docker-compose.yaml up -d > build.txt"]
  }

  provisioner "shell" {
    inline  = ["curl http://169.254.169.254/latest/meta-data/ami-id >> result.txt"]
  }

}

