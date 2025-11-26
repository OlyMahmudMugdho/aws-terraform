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
