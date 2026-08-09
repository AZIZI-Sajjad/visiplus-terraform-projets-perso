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

# Récupération de la policy AWS managée "AdministratorAccess".
# C'est un data source : on ne crée rien, on lit une policy qui existe
# déjà côté AWS pour récupérer son ARN et l'attacher à un user.
# AdministratorAccess = accès admin total (Action "*" sur Resource "*").
data "aws_iam_policy" "administrator_access" {
  name = "AdministratorAccess"
}

resource "aws_iam_user_policy_attachment" "admin_access_attach" {
user       = aws_iam_user.developer.name
  policy_arn = data.aws_iam_policy.administrator_access.arn
}

