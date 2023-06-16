### MFA enforced on CLI level


Setup new directly attached AWS policy to a user `k3s-admin`.
Copy following policy to 

Navigate to `IAM` section and find `k3s-admin` IAM user in AWS web console. Hit `Permissions` -> `Add permissions` -> `Create inline policy`.
![Create AWS policy to restrict cli with MFA](../img/mfa-1.png)

Switch to `JSON` policy view while creating a new one and copy/paste following codeblock.


```json
{
    "Statement": [
        {
            "Condition": {
                "BoolIfExists": {
                    "aws:MultiFactorAuthPresent": "false"
                }
            },
            "Effect": "Deny",
            "NotAction": [
                "sts:GetSessionToken",
                "iam:ResyncMFADevice",
                "iam:ListVirtualMFADevices",
                "iam:ListUsers",
                "iam:ListServiceSpecificCredentials",
                "iam:ListSSHPublicKeys",
                "iam:ListMFADevices",
                "iam:ListAccountAliases",
                "iam:ListAccessKeys",
                "iam:GetAccountSummary",
                "iam:EnableMFADevice",
                "iam:DeleteVirtualMFADevice",
                "iam:CreateVirtualMFADevice"
            ],
            "Resource": "*",
            "Sid": "MustBeSignedInWithMFA"
        }
    ],
    "Version": "2012-10-17"
}

```


Hit `Review policy`
![Create AWS policy to restrict cli  IAM usr](../img/mfa-2.png)


Assign the policy some name e.g. `k3s-admin-ui-cli-with-mfa` and puhs `Create policy`.
![Create AWS policy to restrict cli  IAM usr](../img/mfa-3.png)


Finally, review `k3s-admin` IAM user. It should have by now two permissions policies:
- `AdministratorAccess`
- `k3s-admin-ui-cli-with-mfa`


![Create AWS policy to restrict cli  IAM usr](../img/mfa-4.png)


#### Test whether MFA is enforced at both Web UI and CLI level


Generate `Access keys` for `k3s-admin` IAM user first.

![Create AWS policy to restrict cli  IAM usr](../img/mfa-5.png)
![Create AWS policy to restrict cli  IAM usr](../img/mfa-6.png)
![Create AWS policy to restrict cli  IAM usr](../img/mfa-7.png)

Setup aws cli locally (create a new AWS PROFILE)

```bash
aws configure --profile k3s-admin
```

![Create AWS policy to restrict cli  IAM usr](../img/mfa-8.png)




Create a sample Terraform code in a subfolder `test-mfa` for `k3s-admin` user to test MFA at CLI level.

```bash
export AWS_DEFAULT_PROFILE=k3s-admin

env | grep AWS
AWS_DEFAULT_PROFILE=k3s-admin

mkdir -p test-mfa

cat <<EOF > test-mfa/main.tf
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleInstance"
  }
}
EOF

cd test-mfa

# init/plan should go through without any problem
terraform init
terraform plan
terraform apply

  Enter a value: yes

aws_instance.example: Creating...
╷
│ Error: creating EC2 Instance: UnauthorizedOperation: You are not authorized to perform this operation. Encoded authorization failure message: fnWGjUOFSHpsg4YQUytxJHcHOKuProzqIzsuYPfIDS5QRL6q32MhqLWCJ_x5jjiZ5U8_6nYku1vXtHmsIcrnhqPSmZg6FSNVqgbSG0Q2_DGtUkHSw6MQ1wMYCyWEB-MAdKBsf1J9CFXGGAIe1fTJC-uQMSkyzokJlQQOo6HntRl_TiSvRxC4krNqGKb59yqBuhFjY8wZONKa36yBtDq_x_mZMlZAh5-fgMynvBIoaNoTiGAFM9dvTWVg4bawib1T7keJvUqzpQATVDfnG40fNykU7YRTQOO3NMpTr6KpwM5tpAJASjryqV2co8B_wvNCubF4BhVpUa5ZCtRv7rPqJSjN7Y6CfFI0znq5DV0Eploesix_X5Q1ARzlvvqE31rza0ZCnc7j-NFtDoKzfW-rSQdi2idsxUcDmT9EaVKFUibxHBwpT7j7pThE38yAUzVqwgjk0af-hINgaW6rrmxjMKs5PFIiwlFvwVYwIgEAWQ3PMpQQvGdVn1hrSmBZU_KbEI0QML1IE6txXhkqEBUmBDpzhtTj34o7iHKXVeUt8TD7vcGYHcZSGuvV3CjnAI2z0C1h9S7yYndHdEsmHeOaA4rcx_xwR7RInhg_q10DOp3bRh1YiaLnnxm7EZFTZ_msPYLbYanwR1KD6SQJNC1zOYVWPFfdimQnQG9TsbNfvi2xn4EsejhGkJOqEFO2TDN4Ckv9CBwpUmOIOU6MkX-EdN72L4XGFkefKQetrlsTjUM9GPTzLopvgh_-9y_DlxZ2CLmDgI9M4cK7gnTF8KvPUXCNKyXL4Lrne4lrFIAg5Og6vnVtEvRgM9q-1idGhVLCOmNUQ6DKSmxylYHePQcYKIVJmsdMn0i4kzTRFK1MUQZvzbYWuZqmKyjR6C6nNi1hvx1Wq37NRk_-tNiRySXppgsiccOifeTRp25Zvmld41bSVaQT8mh4628A13-7Vg
│       status code: 403, request id: a8d50436-5053-4ab7-94ee-4dbecf412d80
│
│   with aws_instance.example,
│   on main.tf line 5, in resource "aws_instance" "example":
│    5: resource "aws_instance" "example" {
│
╵

```

Despite the fact that the AWS profile that uses IAM user `k3s-admin` (who has got `AdministrationAccess policy`) enforces MFA at CLI level as well. That's why it's important to somehow use MFA code from a phone `Authenicator app`.

#### Solution


```bash
unset $(echo $(env | grep AWS | cut -d"=" -f1))

TOKEN_CODE="183284"

AWS_ACCOUNT_ID="363711084474"
PROFILE="k3s-admin"
IAM_USER="k3s-admin"

token_output=$(aws sts get-session-token \
--serial-number arn:aws:iam::${AWS_ACCOUNT_ID}:mfa/${IAM_USER} \
--token-code ${TOKEN_CODE} \
--profile ${PROFILE})

# Extract the temporary credentials from the command output
export AWS_ACCESS_KEY_ID=$(echo $token_output | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $token_output | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $token_output | jq -r '.Credentials.SessionToken')

# verify that
env | grep AWS

AWS_ACCESS_KEY_ID=ASIAVJLW6W65NGNORLSL
AWS_SECRET_ACCESS_KEY=/LaroClDRhVSO7Pp6DSdX6HE7XyZJb08gFPglvX6
AWS_SESSION_TOKEN=IQoJb3JpZ2luX2VjEO7//////////wEaCXVzLWVhc3QtMSJHMEUCICmnCSBE7zBAk6pMtePEeLxVJ9P44WQ1Anq/oWWB5dTaAiEA8mEdAKFuEFqCbDoDUVPKUT+rYUuiW/gA0bn0g4l79ZMq7wEIRxAAGgwzNjM3MTEwODQ0NzQiDOfwuJh7sVIsx32/7SrMAd3J1aPVOQKT6UIFpgfLS5yCAHuiwwdMvYnU4GcF4XQnPxIcGG4jAujIxE11fcMHVoZFG9r1AczYQGqzsTig1Xp/OGpPSIGH8LHElBTPE0mOnGOSnzt+kKZZK9WHnsZQwleDLFTMfc5OIAL0kXQ7S7/AyYvHc+yYF3pwlLcF8/Fd4I5oX15rw2/3l0mvpqZ/HE5HUpxFRqaAm4UxXJmFhXJliLKxeW8f84hlIXvm1Oa8fSs5+fQyR0In1b8FCNsL0GWqSPXce9zUQayLADCW0rGkBjqYAe8zyPghYNAsCsR3445gKV23yVjdQVpBkz1V0/ASJvlInQHWEWV+i5aKZrWmsn2fqjuPAz9Lz3Boa9foE1l6aD5g+X4fyBZsAJ7wM3Q0kAlBfKEXXtcsIMQc6LcS3GaLHwGwuJISTxPjFSfHGeLoZeq4q4linw+bkuVCD/WghWtwkXAZU7bJg+cAYoD4uvZ/eotF9wOs2NDx

# Run terraform code again
terraform init
terraform apply
```
#### Execute terraform code code


Execute `terraform apply` and confirm by typing `yes`

![Create AWS policy to restrict cli  IAM usr](../img/mfa-11.png)


Terraform is reading `AWS_SESSION_TOKEN`, `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` env. variables to connect to AWS and provision a simple EC2 instance.
![Create AWS policy to restrict cli  IAM usr](../img/mfa-9.png)

Verify that EC2 was created by logging in to AWS Web Console using `k3s-admin` user, its `password` and MFA code from tour `Authenticator app`.

![Create AWS policy to restrict cli  IAM usr](../img/mfa-9.png)

Verify that instance was created.
![Create AWS policy to restrict cli  IAM usr](../img/mfa-10.png)


#### Delete this testing EC2 instance


```bash
[arch:test-mfa master()U] terraform destroy

aws_instance.example: Refreshing state... [id=i-097a5628be7cb245e]

Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_instance.example will be destroyed
  - resource "aws_instance" "example" {
      - ami                                  = "ami-0c94855ba95c71c99" -> null
      - arn                                  = "arn:aws:ec2:us-east-1:363711084474:instance/i-097a5628be7cb245e" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "us-east-1c" -> null
      ...
          - tags                  = {} -> null
          - throughput            = 0 -> null
          - volume_id             = "vol-07d15add1c27f995f" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp2" -> null
        }
    }

Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_instance.example: Destroying... [id=i-097a5628be7cb245e]
aws_instance.example: Still destroying... [id=i-097a5628be7cb245e, 10s elapsed]
aws_instance.example: Still destroying... [id=i-097a5628be7cb245e, 21s elapsed]
aws_instance.example: Still destroying... [id=i-097a5628be7cb245e, 31s elapsed]
aws_instance.example: Destruction complete after 32s

Destroy complete! Resources: 1 destroyed.

```

![Create AWS policy to restrict cli  IAM usr](../img/mfa-12.png)
