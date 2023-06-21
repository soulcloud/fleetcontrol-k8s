variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
}

variable "subnet_cidr_block" {
  description = "CIDR block for the primary subnet"
}

variable "env_prefix" {
  description = "Prefix to be used for naming resources"
}


variable "private_key_location" {
  description = "Local file path for the private SSH key"
}

variable "public_key_location" {
  description = "Local file path for the public SSH key"
}

variable "avail_zone_1" {
  description = "Availability zone for the primary subnet"
}

variable "avail_zone_2" {
  description = "Availability zone for the primary subnet"
}

variable "ami_ubuntu" {
  description = "AMI ID for Ubuntu Server"
}

variable "volume_type" {
  description = "Type of EBS volume to attach to the instance"
}

variable "volume_size_small" {
  description = "Size of the EBS volume for the primary instance"
}
