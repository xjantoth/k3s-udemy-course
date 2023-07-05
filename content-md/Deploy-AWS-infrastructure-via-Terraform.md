### Deploy AWS infrastructure via Terraform


#### Generate SSH keys

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

```

#### Copy a copy of SSH public key to terraform/ folder

```bash
cp ~/.ssh/k3s-course.pub .
```

#### Finding proper AMI image

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

#### Deploy Terraform infrastructure

```bash
cd terraform/
ls -al

unset $(echo $(env | grep AWS | cut -d"=" -f1))
export AWS_DEFAULT_PROFILE=k3s-restrictive-no-mfa
env | grep AWS

[arch:k3s-udemy-course master()U] aws sts get-caller-identity
{
    "UserId": "AIDAVJLW6W65GFPJYMNSU",
    "Account": "363711084474",
    "Arn": "arn:aws:iam::363711084474:user/k3s-restrictive-no-mfa"
}


terraform init
terraform validate
terraform plan
terraform apply
```


#### Explore deployed AWS Infrastructure

```bash
export AWS_DEFAULT_PROFILE=k3s-restrictive-no-mfa
env | grep AWS

terraform state list
terraform output
...
ssh_command_master = "ssh -i ~/.ssh/k3s-course ubuntu@3.92.203.125"
ssh_command_node = "ssh -i ~/.ssh/k3s-course ubuntu@3.95.154.10"

# Explore Kubernetes node/pods

kubectl get nodes
kubectl get pods -A


# Master Kubernetes node
aws ssm get-parameters --names k3s_token --query 'Parameters[0].Value' --output text --region us-east-1

aws ssm put-parameter --name "k3s_token" \
  --value "some-awesome-new-value" \
  --type "String" --overwrite \
  --region us-east-1

curl http://169.254.169.254/latest/meta-data/iam/info
```
