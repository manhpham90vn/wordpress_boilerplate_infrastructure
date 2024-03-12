resource "tls_private_key" "Create_SSH_Key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "Generate_Pem_File" {
  content  = tls_private_key.Create_SSH_Key.private_key_pem
  filename = "${path.root}/${var.ssh_key_name}.pem"
  file_permission = "0400"
}

resource "aws_key_pair" "SSH_Key_Pair" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.Create_SSH_Key.public_key_openssh
}