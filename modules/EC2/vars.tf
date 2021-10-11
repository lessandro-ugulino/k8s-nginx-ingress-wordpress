
variable "cluster_name" {}

variable "sgp_master_k8s_name" {}
variable "sgp_master_k8s_description" {}

variable "sgp_nodes_k8s_name" {}
variable "sgp_nodes_k8s_description" {}
variable "sgp_rds_k8s_name" {}
variable "sgp_rds_k8s_description" {}

variable "vpc_id" {}
variable "vpc_cidr" {}

variable "key_pair_name" {}
variable "subnet_pub_id" {}
variable "subnet_pub_b_id" {}
variable "ec2_k8s_instance_type" {}
variable "subnet_prv_b_id" {}
variable "subnet_prv_id" {}
variable "ec2_k8s_master_name" {}
variable "ec2_k8s_worker_name" {}
variable "ec2_k8s_worker_2_name" {}

variable "aws_nat_gateway_id" {}

variable "instance_profile_k8s_master_name" {}
variable "instance_profile_k8s_nodes_name" {}
variable "aws_db_instance_endpoint" {}

