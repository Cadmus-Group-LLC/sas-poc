variable "aws_region" {
  description = "Region for the VPC"
  default = "us-west-2"
}
variable "access_key" {}

variable "secret_key" {}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.0.1.0/28"
}

variable "private_subnet_cidr1" {
  description = "CIDR for the private A subnet"
  default = "10.0.1.32/27"
}

variable "private_subnet_cidr2" {
  description = "CIDR for the private B subnet"
  default = "10.0.1.64/27"
}
variable "private_subnet_cidr3" {
  description = "CIDR for the private spare subnet"
  default = "10.0.1.96/27"
}

variable "ami" {
  description = "AMI for EC2"
  default = "ami-4fffc834"
}

variable "key_path" {
  description = "SSH Public Key path"
  default = "/home/core/.ssh/id_rsa.pub"
}