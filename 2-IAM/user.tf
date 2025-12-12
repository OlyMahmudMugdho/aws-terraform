## IAM User Setup
resource "aws_iam_user" "iam_user" {
  name = var.user_name
}


# Creates the console login profile and generates a random password (initial login forces reset)
resource "aws_iam_user_login_profile" "iam_user_login_profile" {
  user                    = aws_iam_user.iam_user.name
  password_reset_required = true
}
