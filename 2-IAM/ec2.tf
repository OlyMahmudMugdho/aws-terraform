# Security Group to allow SSH (port 22)
resource "aws_security_group" "ssh_sg" {
  name        = "management-server-sg"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch an EC2 Instance
resource "aws_instance" "management_server" {
  ami                    = "ami-0b46816ffa1234887"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.management_key.key_name
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]

  # Attach the IAM Role via the Instance Profile
  iam_instance_profile   = aws_iam_instance_profile.s3_manager_profile.name

  tags = {
    Name = "management-server"
  }
}