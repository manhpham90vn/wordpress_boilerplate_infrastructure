locals {
  db_identifier = "mydb"
  db_subnet_group_name = "my-db-subnet-group"
  final_snapshot_identifier = "my-final-snapshot"
}

resource "aws_db_instance" "DB" {
  allocated_storage = 10
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "8.0.36"
  instance_class = var.db_instance_class
  identifier = local.db_identifier
  username = var.db_user
  password = var.db_password
  skip_final_snapshot = true
  final_snapshot_identifier = local.final_snapshot_identifier
  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name = aws_db_subnet_group.DB_Subnet.name
  backup_retention_period = 7
  backup_window = "03:00-04:00"
  maintenance_window = "Mon:04:00-Mon:04:30"
  multi_az = false
  publicly_accessible = false
}

resource "aws_db_subnet_group" "DB_Subnet" {
  name = local.db_subnet_group_name
  subnet_ids = var.subnet_ids
}