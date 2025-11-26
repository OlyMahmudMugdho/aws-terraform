resource "aws_instance" "web-server" {
  region          = var.region
  ami             = "ami-0a716d3f3b16d290c"
  key_name        = aws_key_pair.demo-key-pair-tf.key_name
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.demo-sg.name]

  user_data = <<-EOF
  #!/bin/bash
  apt update -y
  apt install nginx -y
  systemctl enable nginx
  systemctl start nginx
EOF

  tags = {
    Name = "web-server"
  }
}


resource "aws_security_group" "demo-sg" {
  name   = "demo-sg"
  region = var.region
  ingress {
    description = "Allow SSH and all outbound traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 443
    to_port     = 443
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
