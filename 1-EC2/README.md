# EC2 Automation with Terraform on AWS

This project uses Terraform to provision an EC2 instance on AWS. It includes automated SSH key generation, security group configuration, and Nginx installation through a user data script.



## Overview

The configuration defines:

* AWS provider setup
* Variable inputs
* TLS-based SSH key generation
* EC2 instance creation
* Security group rules
* Outputs for public IP and DNS

The goal is to deploy a fully configured Nginx web server using reproducible infrastructure code.



## Project Structure

```
.
├── instance.tf
├── key_pair.tf
├── output.tf
├── provider.tf
├── terraform.tfvars
└── variables.tf
```



## Provider Configuration

`provider.tf`

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.15.0"
    }
  }
}

provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}
```

This block configures Terraform to use the AWS provider.
For production usage, AWS credentials should be supplied through environment variables or AWS CLI, not stored directly in configuration files.



## Variables

`variables.tf`

```hcl
variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "region" {
  type    = string
  default = "eu-north-1"
}

variable "file_name" {
  description = "Name of the key pair"
  type        = string
}
```

These variables allow customization of the region, credentials, and private key filename.



## SSH Key Pair Generation

`key_pair.tf`

```hcl
resource "tls_private_key" "rsa-4096-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "local_file" "tf_key" {
  content  = tls_private_key.rsa-4096-key.private_key_pem
  filename = var.file_name
}

resource "aws_key_pair" "demo-key-pair-tf" {
  key_name   = "demo-key-pair-tf"
  public_key = tls_private_key.rsa-4096-key.public_key_openssh
}
```

This configuration:

* Generates an RSA 4096-bit key
* Stores the private key locally
* Uploads the public key to AWS for EC2 access



## EC2 Instance Configuration

`instance.tf`

```hcl
resource "aws_instance" "web-server" {
  ami             = "ami-0a716d3f3b16d290c"
  instance_type   = "t3.micro"
  key_name        = aws_key_pair.demo-key-pair-tf.key_name
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
```

The instance launches Ubuntu 24.04 and runs an initialization script that installs and enables Nginx.

### Security Group

```hcl
resource "aws_security_group" "demo-sg" {
  name = "demo-sg"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS access"
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
```

Port access:

* 22 for SSH
* 80 for HTTP
* 443 for HTTPS
* Unrestricted outbound traffic



## Outputs

`output.tf`

```hcl
output "aws_instance_public_ip" {
  value = aws_instance.web-server.public_ip
}

output "aws_instance_public_dns" {
  value = aws_instance.web-server.public_dns
}
```

These outputs provide the public IP and DNS for easy access after deployment.



## Variable Values

`terraform.tfvars`

```hcl
region = "eu-north-1"

access_key = "YOUR_ACCESS_KEY"
secret_key = "YOUR_SECRET_KEY"
file_name  = "demo-key.pem"
```

Environment variables may also be used:

```bash
export TF_VAR_access_key="YOUR_ACCESS_KEY"
export TF_VAR_secret_key="YOUR_SECRET_KEY"
```



## Deployment

Initialize, review, and apply the configuration:

```bash
terraform init
terraform plan
terraform apply
```

After deployment:

* The key pair is generated
* The security group is created
* The EC2 instance is provisioned
* Nginx is installed and started
* Public IP and DNS are displayed

Opening the public IP in a browser should show the default Nginx page.



## Verification

SSH access:

```bash
chmod 400 demo-key.pem
ssh -i demo-key.pem ubuntu@<public_ip>
```

Check Nginx status:

```bash
sudo systemctl status nginx
```


## Cleanup

To remove all resources:

```bash
terraform destroy
```

Terraform will safely delete the EC2 instance, security group, and key pair.
