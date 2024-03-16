output "data" {
  value = {
    rds_endpoint = aws_db_instance.DB.endpoint
  }
}