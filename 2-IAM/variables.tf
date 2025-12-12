variable "region" {
  description = "AWS region for the EC2 instance"
  type        = string
  default     = "eu-north-1"
}

variable "access_key" {
  type = string
}


variable "secret_key" {
  type = string
}


variable "user_name" {
  description = "The name for the IAM user"
  type        = string
  default     = "ali"
}

variable "s3_bucket_name" {
  description = "A globally unique name for the S3 bucket"
  type        = string
}

variable "key_pair_name" {
  description = "Name for the EC2 key pair"
  type        = string
  default     = "management-key"
}

variable "public_key" {
  description = "SSH public key content (e.g., from ~/.ssh/id_rsa.pub)"
  type        = string
}