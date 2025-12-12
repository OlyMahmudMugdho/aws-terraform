# Generate the private key locally
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Write the private key to a local file for SSH access
resource "local_file" "private_key_file" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/${var.key_pair_name}.pem"
  file_permission = "0600" 
}


# Create the AWS Key Pair using the generated public key
resource "aws_key_pair" "management_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.ssh_key.public_key_openssh
  depends_on = [local_file.private_key_file] 
}