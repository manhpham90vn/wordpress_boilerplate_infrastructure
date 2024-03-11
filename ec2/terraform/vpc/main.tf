locals {
  vpc_name = "My VPC"
  public_subnet_name = "Public Subnet"
  gateway_name = "Internet Gateway"
  public_route_table_name = "Public Route Table"
  public_security_groups_name = "Public Security Group"
}

resource "aws_vpc" "MyVPC" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "${local.vpc_name}"
  }
}

resource "aws_subnet" "Public_Subnet" {
  count             = length(var.public_subnet)
  vpc_id            = aws_vpc.MyVPC.id
  cidr_block        = var.public_subnet[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name = "${local.public_subnet_name}-${count.index}"
  }
}

resource "aws_internet_gateway" "Internet_Gateway" {
  vpc_id = aws_vpc.MyVPC.id
  
  tags = {
    Name = "${local.gateway_name}"
  }
}

resource "aws_route_table" "Public_Route_Table" {
  vpc_id = aws_vpc.MyVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet_Gateway.id
  }

  tags = {
    "Name" = "${local.public_route_table_name}"
  }
}

resource "aws_route_table_association" "Public_Association" {
  for_each       = { for k, v in aws_subnet.Public_Subnet : k => v }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.Public_Route_Table.id
}

resource "aws_security_group" "Public_Security_Group" {
  name        = "${local.public_security_groups_name}"
  description = "${local.public_security_groups_name}"
  vpc_id      = aws_vpc.MyVPC.id

  tags = {
    "Name" = "${local.public_security_groups_name}"
  }

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [var.ssh_ip]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Mariadb"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = [var.ssh_ip]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }]

  egress = [
    {
      description      = "Allow all outgoing traffics"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}