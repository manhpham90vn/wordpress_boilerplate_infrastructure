locals {
  user = "ec2-user"
  name = "MyEC2Instance"
}

resource "aws_instance" "MyEC2InstancePublic" {
  count                       = var.countInstancesPublic
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.public_subnet_id[count.index]
  vpc_security_group_ids      = [var.public_security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "${local.name}-${count.index}-Public"
  }
}

resource "local_file" "config_hosts" {
  content = templatefile("${path.root}/../scripts/install.tpl",
    {
      mysql_root_password = var.mysql_root_password
      mysql_db_user       = var.mysql_db_user
      mysql_db_password   = var.mysql_db_password
      mysql_db_name       = var.mysql_db_name
      ec2_domain          = var.domain_name
      ssh_ip              = var.ssh_ip
    }
  )
  filename = "${path.root}/../scripts/install.sh"
}

resource "null_resource" "Copy_file" {

  provisioner "file" {
    source      = "${path.root}/../scripts/install.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "file" {
    source      = "${path.root}/../certificate/fullchain.pem"
    destination = "/home/ec2-user/fullchain.pem"
  }

  provisioner "file" {
    source      = "${path.root}/../certificate/privkey.pem"
    destination = "/home/ec2-user/privkey.pem"
  }

  connection {
    type        = "ssh"
    user        = local.user
    private_key = var.private_key
    host        = aws_instance.MyEC2InstancePublic[0].public_ip
  }
}

resource "null_resource" "Run_Install" {

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/ec2-user/fullchain.pem /etc/nginx/conf.d/fullchain.pem",
      "sudo mv /home/ec2-user/privkey.pem /etc/nginx/conf.d/privkey.pem",
      "chmod +x /tmp/install.sh",
      "sudo /tmp/install.sh"
    ]
  }

  connection {
    type        = "ssh"
    user        = local.user
    private_key = var.private_key
    host        = aws_instance.MyEC2InstancePublic[0].public_ip
  }

  depends_on = [ null_resource.Copy_file ]
}