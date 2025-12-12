## IAM Groups and Permissions
resource "aws_iam_group" "s3_manager" {
  name = "s3-manager"
}

resource "aws_iam_group" "ec2_admin" {
  name = "ec2-admin"
}

# Attach the managed policy 'AmazonS3FullAccess'
resource "aws_iam_group_policy_attachment" "s3_manager_policy_attach" {
  group      = aws_iam_group.s3_manager.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Attach the managed policy 'AmazonEC2FullAccess'
resource "aws_iam_group_policy_attachment" "ec2_admin_policy_attach" {
  group      = aws_iam_group.ec2_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# Attach the user to the s3-manager group
resource "aws_iam_group_membership" "s3_manager_membership" {
  name  = "ali-s3-membership"
  users = [
    aws_iam_user.iam_user.name,
  ]
  group = aws_iam_group.s3_manager.name 
}

# Attach the user to the ec2-admin group
resource "aws_iam_group_membership" "ec2_admin_membership" {
  name  = "ali-ec2-membership"
  users = [
    aws_iam_user.iam_user.name,
  ]
  group = aws_iam_group.ec2_admin.name 
}