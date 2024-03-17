provider "aws" {
  region = "us-east-1"
  alias = "us"
}

resource "aws_acm_certificate" "Certificate_Manager" {
  private_key = "${file("${path.root}/../certificate/privkey.pem")}"
  certificate_body = "${file("${path.root}/../certificate/cert.pem")}"
  certificate_chain = "${file("${path.root}/../certificate/fullchain.pem")}"
}

resource "aws_acm_certificate" "Certificate_Manager_US" {
  private_key = "${file("${path.root}/../certificate/privkey.pem")}"
  certificate_body = "${file("${path.root}/../certificate/cert.pem")}"
  certificate_chain = "${file("${path.root}/../certificate/fullchain.pem")}"
  provider = aws.us
}