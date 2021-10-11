resource "random_password" "password" {
  length           = 8
  special          = false
  override_special = "_%@/"
}

resource "aws_ssm_parameter" "rds_wordpress_secret" {
  name        = "/rds/k8s-lessandro/password"
  description = "Password for RDS K8s"
  type        = "SecureString"
  overwrite   = false
  value       = random_password.password.result

  tags = {
    environment                                 = "production"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}
resource "aws_db_subnet_group" "rds_wordpress_db_group" {
  name       = var.rds_wordpress_db_group_name
  subnet_ids = [var.subnet_prv_id, var.subnet_prv_b_id]

  tags = {
    Name                                        = var.rds_wordpress_db_group_name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_db_instance" "rds_wordpress" {
  allocated_storage       = 10
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  name                    = "wpdb"
  username                = "wpmysql"
  password                = aws_ssm_parameter.rds_wordpress_secret.value
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.rds_wordpress_db_group.name
  vpc_security_group_ids  = [var.sgp_rds_k8s_id]
  identifier              = var.rds_wordpress_name
  skip_final_snapshot     = true
  backup_retention_period = 0
  apply_immediately       = true

  tags = {
    Name                                        = var.rds_wordpress_name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}
