data "aws_availability_zones" "available" {}

variable "vpc_cidr" {}
variable "vpc_name" {}
variable "vpc_id" {}

variable "subnet_pub_cidr" {}
variable "subnet_pub_name" {}
variable "subnet_pub_id" {}

variable "subnet_pub_b_cidr" {}
variable "subnet_pub_b_name" {}
variable "subnet_pub_b_id" {}

variable "subnet_prv_cidr" {}
variable "subnet_prv_name" {}

variable "subnet_prv_b_name" {}
variable "subnet_prv_b_cidr" {}

variable "igw_name" {}
variable "igw_id" {}

variable "nat_name" {}
variable "nat_id" {}

variable "rtb_pub_name" {}
variable "rtb_pub_id" {}

variable "rtb_prv_name" {}

variable "cluster_name" {}
