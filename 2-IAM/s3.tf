resource "aws_s3_bucket" "test_bucket" {
  bucket = var.s3_bucket_name
  tags = {
    Name = "iam-test-bucket-mugdho-2025"
  }
}
