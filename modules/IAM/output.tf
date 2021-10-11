output "instance_profile_k8s_master_name" {
  value = aws_iam_instance_profile.instance_profile_k8s_master.name
}

output "instance_profile_k8s_nodes_name" {
  value = aws_iam_instance_profile.instance_profile_k8s_nodes.name
}
