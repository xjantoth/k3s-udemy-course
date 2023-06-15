### Writing terraform code for 2 AWS EC2 instances

Generate SSH keys

```bash
ssh-keygen -f ~/.ssh/k3s-course -t rsa -b 4096 -C "k3s-course@udemy.com"

...
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/jantoth/.ssh/k3s-course
Your public key has been saved in /home/jantoth/.ssh/k3s-course.pub
The key fingerprint is:
SHA256:ypXf/vfysZNGSExhv01piNjJQux/r/UWrGK3kOeelUQ k3s-course@udemy.com
The key's randomart image is:
+---[RSA 4096]----+
|        ..   o.  |
|        ..+ +.o .|
|        .o =o. E.|
|         o.  oo.o|
|        S . . oo.|
|     . o . o.o.+.|
|      o   .oo.+=o|
|           ++o==*|
|          . =B=**|
+----[SHA256]-----+


# Copy a copy of SSH public key to terraform/ folder
cp ~/.ssh/k3s-course.pub .

```

Check get-caller-identity

```bash
aws sts get-caller-identity --profile k3s-course
{
    "UserId": "AIDAVJLW6W65NFGEHZ3RF",
    "Account": "363711084474",
    "Arn": "arn:aws:iam::363711084474:user/k3s-course-tf"
}

```

Since MFA is enabled we will generate a temporary credentials that Terraform will use when executing `terrafrom apply`.

```bash
# IAM -> choose your IAM user -> Permissions ->   Add Permissions -> Create inline policy -> Json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "MustBeSignedInWithMFA",
            "Effect": "Deny",
            "NotAction": [
                "iam:CreateVirtualMFADevice",
                "iam:DeleteVirtualMFADevice",
                "iam:ListVirtualMFADevices",
                "iam:EnableMFADevice",
                "iam:ResyncMFADevice",
                "iam:ListAccountAliases",
                "iam:ListUsers",
                "iam:ListSSHPublicKeys",
                "iam:ListAccessKeys",
                "iam:ListServiceSpecificCredentials",
                "iam:ListMFADevices",
                "iam:GetAccountSummary",
                "sts:GetSessionToken"
            ],
            "Resource": "*",
            "Condition": {
                "BoolIfExists": {
                    "aws:MultiFactorAuthPresent": "false"
                }
            }
        }
    ]
}
# - - - - - - - - - - - - - - -

# k3s-course-no-mfa-restrictive
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowEC2InstanceCreation",
            "Effect": "Allow",
            "Action": [
                "ec2:RunInstances",
                "ec2:DescribeInstances",
                "ec2:TerminateInstances",
                "ec2:CreateTags",
                "ec2:DescribeInstanceTypes",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeTags",
                "ec2:DescribeInstanceAttribute",
                "ec2:DescribeVolumes",
                "ec2:DescribeInstanceCreditSpecifications"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowKeyPairManagement",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateKeyPair",
                "ec2:DescribeKeyPairs",
                "ec2:DeleteKeyPair",
                "ec2:ImportKeyPair"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowSecurityGroupManagement",
            "Effect": "Allow",
            "Action": [
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
                "ec2:StartInstances"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowVPCAndAvailabilityZoneManagement",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeSubnets",
                "ec2:DescribeRouteTables",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeVpcClassicLink",
                "ec2:DescribeVpcClassicLinkDnsSupport",
                "ec2:DescribeVpcEndpoints",
                "ec2:DescribeVpcEndpointConnectionNotifications",
                "ec2:DescribeVpcEndpointConnections",
                "ec2:DescribeVpcEndpointServiceConfigurations",
                "ec2:DescribeVpcEndpointServicePermissions",
                "ec2:DescribeVpcEndpointServices",
                "ec2:DescribeVpcPeeringConnections",
                "ec2:DescribeVpcs"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowBucketListing",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::k3scourse"
        },
        {
            "Sid": "AllowObjectOperations",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:ListBucketMultipartUploads"
            ],
            "Resource": "arn:aws:s3:::k3scourse/*"
        }
    ]
}
```


### Finding proper AMI imagee

```bash
[arch:terraform master()U] aws ssm get-parameters --names /aws/service/canonical/ubuntu/server/20.04/stable/current/amd64/hvm/ebs-gp2/ami-id
{
    "Parameters": [
        {
            "Name": "/aws/service/canonical/ubuntu/server/20.04/stable/current/amd64/hvm/ebs-gp2/ami-id",
            "Type": "String",
            "Value": "ami-0efd657a42099f98f",
            "Version": 273,
            "LastModifiedDate": "2023-06-03T01:45:16.166000+02:00",
            "ARN": "arn:aws:ssm:us-east-1::parameter/aws/service/canonical/ubuntu/server/20.04/stable/current/amd64/hvm/ebs-gp2/ami-id",
            "DataType": "aws:ec2:image"
        }
    ],
    "InvalidParameters": []
}

```
