output "data" {
  value = {
    public_security_group_id = aws_security_group.Public_Security_Group.id
    public_subnet_id = aws_subnet.Public_Subnet.*.id
  }
}