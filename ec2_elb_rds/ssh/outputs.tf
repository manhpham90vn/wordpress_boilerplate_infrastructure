output "data" {
  value = {
    key_name = aws_key_pair.SSH_Key_Pair.key_name
    private_key = tls_private_key.Create_SSH_Key.private_key_pem
  }
}