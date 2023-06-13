resource "aws_iam_user" "this" {
  name = "k3s-restrictive-no-mfa"
}

resource "aws_iam_policy" "restrictive" {
  name        = "restrictive-rights-with-no-mfa"
  description = "Custom TF policy that is restricted to EC2 and specific S3 bucket"
  policy      = data.aws_iam_policy_document.restrictive.json
}

resource "aws_iam_user_policy_attachment" "example_attachment" {
  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.restrictive.arn
}

data "aws_iam_policy_document" "restrictive" {
  statement {
    sid       = "AllowEC2Operations"
    effect    = "Allow"
    resources = ["*"]
    actions   = [
      "ec2:RunInstances",
      "ec2:DescribeInstances",
      "ec2:TerminateInstances",
      "ec2:CreateTags",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeTags",
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeVolumes",
      "ec2:DescribeInstanceCreditSpecifications",
      "ec2:CreateKeyPair",
      "ec2:DescribeKeyPairs",
      "ec2:DeleteKeyPair",
      "ec2:ImportKeyPair",
      "ec2:CreateSecurityGroup",
      "ec2:DescribeSecurityGroups",
      "ec2:DeleteSecurityGroup",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:StopInstances",
      "ec2:ModifyInstanceAttribute",
      "ec2:StartInstances",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeSubnets",
      "ec2:DescribeRouteTables",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeVpcClassicLink",
      "ec2:DescribeVpcClassicLinkDnsSupport",
      "ec2:DescribeVpcEndpoints",
      "ec2:DescribeVpcEndpointConnectionNotifications",
      "ec2:DescribeVpcEndpointConnections",
      "ec2:DescribeVpcEndpointServiceConfigurations",
      "ec2:DescribeVpcEndpointServicePermissions",
      "ec2:DescribeVpcEndpointServices",
      "ec2:DescribeVpcPeeringConnections",
      "ec2:DescribeVpcs",
    ]
  }

  statement {
    sid       = "AllowBucketListing"
    effect    = "Allow"
    resources = ["arn:aws:s3:::k3scourse"]
    actions   = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
  }

  statement {
    sid       = "AllowObjectOperations"
    effect    = "Allow"
    resources = ["arn:aws:s3:::k3scourse/*"]
    actions   = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucketMultipartUploads",
    ]
  }
}
