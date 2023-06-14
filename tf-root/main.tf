variable "k3s_restrictive_no_mfa" {
  type    = string
  default = "k3s-restrictive-no-mfa"
}

variable "k3s_admin" {
  type    = string
  default = "k3s-admin"
}

variable "s3_bucket_name" {
  type    = string
  default = "k3scourse"
}

# ---------------------------------------------------------------------------------------
resource "aws_iam_user" "k3s_restrictive" {
  name = var.k3s_restrictive_no_mfa
}

resource "aws_iam_user" "k3s_ui_cli_admin_mfa" {
  name = var.k3s_admin
}

resource "aws_iam_policy" "restrictive" {
  name        = "restrictive-rights-with-no-mfa"
  description = "Custom TF policy that is restricted to EC2 and specific S3 bucket"
  policy      = data.aws_iam_policy_document.restrictive.json
}

resource "aws_iam_user_policy_attachment" "example_attachment" {
  user       = aws_iam_user.k3s_restrictive.name
  policy_arn = aws_iam_policy.restrictive.arn
}


resource "aws_iam_policy" "mfa" {
  name        = "k3s-admin-ui-cli-with-mfa"
  description = "Custom TF policy that enforces MFA at cli level"
  policy      = data.aws_iam_policy_document.mfa.json
}

resource "aws_iam_user_policy_attachment" "k3s_admin_ui_cli_with_mfa" {
  user       = aws_iam_user.k3s_ui_cli_admin_mfa.name
  policy_arn = aws_iam_policy.mfa.arn
}

resource "aws_iam_user_policy_attachment" "admin_attachment" {
  user       = aws_iam_user.k3s_ui_cli_admin_mfa.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

