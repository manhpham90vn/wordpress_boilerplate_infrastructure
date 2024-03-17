output "data" {
  value = {
    public_ip = aws_instance.MyEC2InstancePublic[0].public_ip
  }
}