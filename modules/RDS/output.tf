resource "local_file" "rds_wordpress_var_file" {
  depends_on = [aws_db_instance.rds_wordpress]
  content    = <<-EOT
    rds_endpoint: ${aws_db_instance.rds_wordpress.endpoint}
  EOT
  filename   = "roles/apps/wordpress/vars/main.yml"
}

output "aws_db_instance_endpoint" {
  value = aws_db_instance.rds_wordpress.endpoint
}
