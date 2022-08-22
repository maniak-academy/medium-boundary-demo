resource "tls_private_key" "pkiworker" {
  algorithm = "RSA"
}

resource "aws_key_pair" "pkiworker" {
  public_key = tls_private_key.pkiworker.public_key_openssh
}

resource "null_resource" "key" {
  provisioner "local-exec" {
    command = "echo \"${tls_private_key.pkiworker.private_key_pem}\" > ${aws_key_pair.pkiworker.key_name}.pem"
  }

  provisioner "local-exec" {
    command = "chmod 600 *.pem"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f *.pem"
  }

}