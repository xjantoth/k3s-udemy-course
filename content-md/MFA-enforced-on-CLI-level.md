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

```bash
TOKEN_CODE="576353"
token_output=$(aws sts get-session-token \
--serial-number arn:aws:iam::363711084474:mfa/k3s-course-tf \
--token-code ${TOKEN_CODE} \
--profile k3s-course)

# Extract the temporary credentials from the command output
export AWS_ACCESS_KEY_ID=$(echo $token_output | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $token_output | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $token_output | jq -r '.Credentials.SessionToken')

export AWS_DEFAULT_PROFILE
# verify that 
env | grep AWS

cd terraform/
terraform init
```
