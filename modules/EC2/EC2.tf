data "http" "my_public_ip" {
  url = "http://checkip.amazonaws.com"
}

resource "aws_security_group" "sgp_master_k8s" {
  name        = var.sgp_master_k8s_name
  vpc_id      = var.vpc_id
  description = var.sgp_master_k8s_description

  ingress {
    description = "All from outside"
    protocol    = "-1"
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = ["${chomp(data.http.my_public_ip.body)}/32"]
  }

  ingress {
    protocol    = "-1"
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name                                        = var.sgp_master_k8s_name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_security_group" "sgp_nodes_k8s" {
  name        = var.sgp_nodes_k8s_name
  vpc_id      = var.vpc_id
  description = var.sgp_nodes_k8s_description
  ingress {
    protocol    = "-1"
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "All from outside"
    protocol    = "-1"
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = ["${chomp(data.http.my_public_ip.body)}/32"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name                                        = var.sgp_nodes_k8s_name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_security_group" "sgp_rds_k8s" {
  name        = var.sgp_rds_k8s_name
  vpc_id      = var.vpc_id
  description = var.sgp_rds_k8s_description
  ingress {
    protocol    = "-1"
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name                                        = var.sgp_rds_k8s_name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

#----AMI----
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

#-----The EC2 Master Node-----
resource "aws_instance" "ec2_k8s_master" {
  ami                    = data.aws_ami.ubuntu.id
  source_dest_check      = false
  instance_type          = var.ec2_k8s_instance_type
  vpc_security_group_ids = [aws_security_group.sgp_master_k8s.id]
  key_name               = var.key_pair_name
  subnet_id              = var.subnet_pub_id
  iam_instance_profile   = var.instance_profile_k8s_master_name
  root_block_device {
    volume_size = 20
  }

  tags = {
    Name                                        = var.ec2_k8s_master_name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_eip" "eip_master" {
  vpc                       = true
  instance                  = aws_instance.ec2_k8s_master.id
  associate_with_private_ip = aws_instance.ec2_k8s_master.private_ip

  tags = {
    Name = var.ec2_k8s_master_name
  }
}

#-----The EC2 Worker Node-----

#-----Node 1------
resource "aws_instance" "ec2_k8s_worker_1" {
  source_dest_check      = false
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ec2_k8s_instance_type
  vpc_security_group_ids = [aws_security_group.sgp_nodes_k8s.id]
  key_name               = var.key_pair_name
  subnet_id              = var.subnet_pub_id
  iam_instance_profile   = var.instance_profile_k8s_nodes_name

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name                                        = var.ec2_k8s_worker_name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_eip" "eip_worker_1" {
  vpc                       = true
  instance                  = aws_instance.ec2_k8s_worker_1.id
  associate_with_private_ip = aws_instance.ec2_k8s_worker_1.private_ip

  tags = {
    Name = var.ec2_k8s_worker_name
  }
}


#-----Node 2------
resource "aws_instance" "ec2_k8s_worker_2" {
  source_dest_check      = false
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ec2_k8s_instance_type
  vpc_security_group_ids = [aws_security_group.sgp_nodes_k8s.id]
  key_name               = var.key_pair_name
  subnet_id              = var.subnet_pub_b_id
  iam_instance_profile   = var.instance_profile_k8s_nodes_name

  root_block_device {
    volume_size = 20
  }

  tags = {
    Name                                        = var.ec2_k8s_worker_2_name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_eip" "eip_worker_2" {
  vpc                       = true
  instance                  = aws_instance.ec2_k8s_worker_2.id
  associate_with_private_ip = aws_instance.ec2_k8s_worker_2.private_ip

  tags = {
    Name = var.ec2_k8s_worker_name
  }
}
