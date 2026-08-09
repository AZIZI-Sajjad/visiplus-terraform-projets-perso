# Basic IAM user

resource "aws_iam_user" "developer" {
  name = var.user_name
  path = var.path

  # Force destroy allows deletion even if the user has non-Terraform-managed resources
  force_destroy = true

  tags = {
    Team        = var.team
    Department  = var.department
    Environment = var.environment
  }
}

# Login profile for console access
resource "aws_iam_user_login_profile" "developer" {
  user                    = aws_iam_user.developer.name
  password_reset_required = true # Force password change on first login
}

# Access key for programmatic access
resource "aws_iam_access_key" "developer" {
  user = aws_iam_user.developer.name
}

