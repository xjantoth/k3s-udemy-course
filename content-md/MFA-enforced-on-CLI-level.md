### MFA enforced on CLI level

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
