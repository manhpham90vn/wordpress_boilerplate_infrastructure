output "data" {
  value = {
    vpc_id = aws_vpc.MyVPC.id
    public_security_group_id = aws_security_group.Public_Security_Group.id
    private_security_group_id = aws_security_group.Private_Security_Group.id
    public_subnet_id = aws_subnet.Public_Subnet.*.id
    private_subnet_id = aws_subnet.Private_Subnet.*.id
  }
}