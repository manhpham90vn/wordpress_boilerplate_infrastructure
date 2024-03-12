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

resource "local_file" "Configs" {
  content = templatefile("${path.root}/../scripts/install.tpl",
    {
      mysql_root_password = var.mysql_root_password
      mysql_db_user       = var.mysql_db_user
      mysql_db_password   = var.mysql_db_password
      mysql_db_name       = var.mysql_db_name
      ec2_domain          = var.domain_name
      ssh_ip              = var.ssh_ip
      fullchain = file("${path.root}/../certificate/fullchain.pem")
      privkey = file("${path.root}/../certificate/privkey.pem")
    }
  )
  filename = "${path.root}/../scripts/install.sh"
}

resource "null_resource" "Run_Install" {

  provisioner "file" {
    source      = "${path.root}/../scripts/install.sh"
    destination = "/tmp/install.sh"
  }

  provisioner "remote-exec" {
    inline = [
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

  depends_on = [ local_file.Configs ]
}