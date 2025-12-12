# IAM Role for EC2
# Trust Policy Document: Allows the EC2 service to assume this role (sts:AssumeRole)
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "s3_manager_role" {
  name               = "s3-manager-role"
  # References the trust policy defined in policies.tf
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}


data "aws_iam_policy_document" "ec2_s3_list_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListAllMyBuckets",
    ]
    resources = [
      "*",
    ]
  }
}


resource "aws_iam_policy" "ec2_s3_list_policy" {
  name        = "EC2S3ListPolicy"
  description = "Allows an EC2 instance to list all S3 buckets."
  policy      = data.aws_iam_policy_document.ec2_s3_list_policy_doc.json
}


# Attach the custom policy that allows s3:ListAllMyBuckets
resource "aws_iam_role_policy_attachment" "s3_list_role_attach" {
  role       = aws_iam_role.s3_manager_role.name
  policy_arn = aws_iam_policy.ec2_s3_list_policy.arn
}

# Create the Instance Profile to link the Role to the EC2 Instance
resource "aws_iam_instance_profile" "s3_manager_profile" {
  name = "s3-manager-profile"
  role = aws_iam_role.s3_manager_role.name
}


# Reference the current account ID for the login URL
data "aws_caller_identity" "current" {}