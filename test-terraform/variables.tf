# ==================================================
 ###  =>  Variables Used ###
# ==================================================
variable "aws_region" {
  description = "Set AWS Region"
  default = "eu-west-2"
}

variable "aws_profile" {
  description = "Set the AWS cli Profile to use"
  default = "ADD PROFILE HERE"
}
variable "name_tag" {
  description = "Set the Name Tag used for filtering specific VPC and Security Groups"
  default = "ADD_TAG"
}

variable "vpc_id" {
  description = "The ID of the AWS VPC"
  default = []
}

variable "vpc_cidr" {
  description = "Value of AWS VPC CIDR"
  default = []
}

variable "instance" {
  description = "Set Instance Type e.g: => t3.medium"
  default = "t2.medium"

}

variable "iam_role" {
  description = "IAM Role to Be Used"
  default = "ADD_ROLE"
}

variable "volume_type" {
  description = "The Type of Volume. Can be standard gp2 or io1 or sc1st1 or gp3"
  default = "gp3"
}

variable "volume_size" {
  description = "Size of the EBS Volume Needed"
  default = "100"
}

variable "key_name" {
  description = "name given to the SSH keys"
  default = "KEY_NAME_YOU_WANT_TO_USE"
}

variable "s3_bucket_name" {
  description = "Name of The Bucket"
  default = "ingotech"
}

variable "env" {
  description = "The Name of current Enviroment Used"
  default = "Development"
}



variable "subnet_cidr" {
  description = "The Subnet CIDR of the Resource"
  default = []
}

variable "account_id" {
  description = "AWS Accout ID Value"
  default = []
}

variable "trusted_role_arn" {
  description = "The ARN of Trusted Role"
  default = []
}

variable "provider_name" {
  description = "The Name of the Provider => AWS"
  default = []
}
