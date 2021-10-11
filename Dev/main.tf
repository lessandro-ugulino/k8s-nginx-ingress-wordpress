provider "aws" {
  profile = "default"
}

module "my_vpc" {
  source       = "../modules/VPC"
  vpc_cidr     = "172.16.0.0/16"
  vpc_name     = "k8s-lessandro-vpc"
  vpc_id       = module.my_vpc.vpc_id
  cluster_name = "kubernetes"

  subnet_pub_name = "k8s-lessandro-sbn-pub-2a"
  subnet_pub_cidr = "172.16.0.0/18"
  subnet_pub_id   = module.my_vpc.subnet_pub_id

  subnet_pub_b_name = "k8s-lessandro-sbn-pub-2b"
  subnet_pub_b_cidr = "172.16.64.0/18"
  subnet_pub_b_id   = module.my_vpc.subnet_pub_b_id

  subnet_prv_cidr = "172.16.128.0/18"
  subnet_prv_name = "k8s-lessandro-sbn-prv-2a"

  subnet_prv_b_cidr = "172.16.192.0/18"
  subnet_prv_b_name = "k8s-lessandro-sbn-prv-2b"

  igw_name = "k8s-lessandro-igw"
  igw_id   = module.my_vpc.igw_id

  nat_name = "k8s-lessandro-nat"
  nat_id   = module.my_vpc.nat_id

  rtb_pub_name = "k8s-lessandro-rtb-pub"
  rtb_pub_id   = module.my_vpc.rtb_pub_id

  rtb_prv_name = "k8s-lessandro-rtb-prv"
}

module "my_iam" {
  source = "../modules/IAM"
}

module "my_ec2" {
  source       = "../modules/EC2"
  vpc_id       = module.my_vpc.vpc_id
  cluster_name = "kubernetes"


  sgp_master_k8s_name        = "sgp-master-k8s-lessandro"
  sgp_master_k8s_description = "Master K8s Security Group"

  sgp_nodes_k8s_name        = "sgp-nodes-k8s-lessandro"
  sgp_nodes_k8s_description = "Nodes K8s Security Group"

  sgp_rds_k8s_name        = "sgp-k8s-lessandro-rds"
  sgp_rds_k8s_description = "Security Group for K8s RDS"

  instance_profile_k8s_nodes_name  = module.my_iam.instance_profile_k8s_nodes_name
  instance_profile_k8s_master_name = module.my_iam.instance_profile_k8s_master_name

  vpc_cidr = module.my_vpc.vpc_cidr

  key_pair_name = "my_key"

  subnet_pub_id   = module.my_vpc.subnet_pub_id
  subnet_pub_b_id = module.my_vpc.subnet_pub_b_id

  ec2_k8s_instance_type = "t2.medium"

  ec2_k8s_master_name   = "ec2-k8s-lessandro-master"
  ec2_k8s_worker_name   = "ec2-k8s-lessandro-node-1"
  ec2_k8s_worker_2_name = "ec2-k8s-lessandro-node-2"

  subnet_prv_id   = module.my_vpc.subnet_prv_id
  subnet_prv_b_id = module.my_vpc.subnet_prv_b_id

  aws_nat_gateway_id = module.my_vpc.nat_id

  aws_db_instance_endpoint = module.my_rds.aws_db_instance_endpoint

}

module "my_rds" {
  source       = "../modules/RDS"
  cluster_name = "kubernetes"

  sgp_rds_k8s_id              = module.my_ec2.sgp_rds_k8s_id
  rds_wordpress_db_group_name = "rds-k8s-wordpress-db-group"

  subnet_prv_id   = module.my_vpc.subnet_prv_id
  subnet_prv_b_id = module.my_vpc.subnet_prv_b_id

  rds_wordpress_name = "k8s-lessandro-rds"
}
