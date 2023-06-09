data "aws_iam_policy_document" "restrictive" {
  statement {
    sid       = "RunInstance"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ec2:RunInstances",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances"
    ]

    condition {
      test     = "StringLikeIfExists"
      variable = "ec2:InstanceType"

      values = [
        "t3.micro",
        "t2.micro",
        "t3a.medium",
      ]
    }
  }

  statement {
    sid       = "AllowEC2Operations"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeVpcs",
      "ec2:DescribeSubnets",
      "ec2:CreateTags",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeRouteTables",
      "ec2:DescribeTags",
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeInstanceCreditSpecifications",
      "ec2:DescribeInstanceTypes",
      "ec2:ModifyInstanceAttribute",
      "ec2:DescribeVolumes",
      "ec2:DescribeVpcAttribute"
    ]
  }


  statement {
    sid       = "AllowKeyPairOperations"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ec2:CreateKeyPair",
      "ec2:DeleteKeyPair",
      "ec2:DescribeKeyPairs",
      "ec2:ImportKeyPair"

    ]
  }

  statement {
    sid       = "AllowSecurityGroupsOperations"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeSecurityGroups",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress"
    ]
  }

  statement {
    sid       = "AllowIAM"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "iam:AddRoleToInstanceProfile",
      "iam:CreateInstanceProfile",
      "iam:CreateRole",
      "iam:DeleteInstanceProfile",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:GetInstanceProfile",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfiles",
      "iam:ListInstanceProfilesForRole",
      "iam:ListRolePolicies",
      "iam:ListRolePolicies",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:TagInstanceProfile",
      "iam:TagRole"
    ]
  }
  statement {
    sid       = "AllowSSMOperations"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ssm:AddTagsToResource",
      "ssm:DeleteParameter",
      "ssm:DescribeParameters",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:ListTagsForResource",
      "ssm:PutParameter"

    ]
  }

  statement {
    sid       = "AllowBucketListing"
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.s3_bucket_name}"]
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
    ]
  }

  statement {
    sid       = "AllowObjectOperations"
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.s3_bucket_name}/*"]
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucketMultipartUploads",
    ]
  }
}
