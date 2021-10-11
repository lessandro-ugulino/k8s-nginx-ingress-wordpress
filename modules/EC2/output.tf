resource "local_file" "ansible_inventory" {
  content  = <<-EOT
      [master]
      ${aws_eip.eip_master.public_ip} ansible_user=ubuntu ansible_connection=ssh

      [nodes]
      ${aws_eip.eip_worker_1.public_ip} ansible_user=ubuntu ansible_connection=ssh
      ${aws_eip.eip_worker_2.public_ip} ansible_user=ubuntu ansible_connection=ssh
  EOT
  filename = "inventory/hosts"
}
resource "null_resource" "provisioner" {
  triggers = {
    always_run = "${timestamp()}"
  }
  depends_on = [aws_instance.ec2_k8s_master, var.aws_nat_gateway_id, var.aws_db_instance_endpoint]
  provisioner "local-exec" {
    command = "ansible-playbook deploy.yml"
  }
}

output "sgp_rds_k8s_id" {
  value = aws_security_group.sgp_rds_k8s.id
}
