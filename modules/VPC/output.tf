
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_pub_id" {
  value = aws_subnet.subnet_pub.id
}

output "subnet_pub_b_id" {
  value = aws_subnet.subnet_pub_b.id
}

output "vpc_cidr" {
  value = aws_vpc.vpc.cidr_block
}

output "subnet_prv_id" {
  value = aws_subnet.subnet_prv.id
}

output "subnet_prv_b_id" {
  value = aws_subnet.subnet_prv_b.id
}
output "nat_id" {
  value = aws_nat_gateway.nat.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "rtb_pub_id" {
  value = aws_route_table.pub_rtb.id
}