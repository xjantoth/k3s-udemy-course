# K3S Udemy course

### Course materials can be found at Github

https://github.com/xjantoth/k3s-udemy-course

### !!! Disclaimer

Make sure to delete all your AWS resources once you are not using it in order to avoid any unexpected charges simply because of forgotten EC2, EBS or any other resources. 

### Prerequisites

- install aws, terraform, kubectl, helm binaries
    - Free Coupon from my previous courses on how to setup AWS, and install all required binaries.
    - https://www.udemy.com/course/learn-devops-helm-helmfile-kubernetes-deployment/?couponCode=588B6996050070A30C8F
    - anyone can post a message in case the coupon has been expired and I would forget to update a link here in this repo

- recommend to create a new email address (just for the sake of this Udemy course)
- AWS Free Tier account
- k3scourse@gmail.com (this email is taken by me)
- keep your passwords to AWS safe e.g. keepass
- setup MFA authentication (recommended)
- 3 AWS regions are supported out of a box for AWS Free tier account
- make sure that datetime is accurate at your workstation

### Setting up AWS Free Tier account

Google "How to create Free Tier AWS account" and use some email address. I would advise to create an email address dedicated for this course.

![AWS Free Tier Account](img/tier-1.png) 

Verification code will be sent to the respective mailbox once email address was written to a "Sign up for AWS" page
![AWS Free Tier Account](img/tier-2.png)

Provide root password. Make sure it is strong enough and save it safely e.g. keepass.
![AWS Free Tier Account](img/tier-3.png) 

Choose "Personal - for your own projects"
![AWS Free Tier Account](img/tier-4.png) 

Enter Bank Account data. However, one should not be charged a penny since Free Tier AWS account will be used.
![AWS Free Tier Account](img/tier-5.png) 


"Text message (SMS)"
![AWS Free Tier Account](img/tier-6.png)

Confirm your identity
![AWS Free Tier Account](img/tier-7.png) 

Choose "Basic support - Free" option.
![AWS Free Tier Account](img/tier-8.png) 

Congratulations.
![AWS Free Tier Account](img/tier-9.png) 

Choose "Root user". Sign in with your email address and previoulsy specified password.
![AWS Free Tier Account](img/tier-10.png) 

Type password.
![AWS Free Tier Account](img/tier-11.png) 

Setup MFA authentication
![AWS Free Tier Account](img/tier-12.png) 


Setup MFA authentication
![AWS Free Tier Account](img/tier-13.png)

Select MFA device. I would recommend to download "Google Authenticator App" to your cell phone.
![AWS Free Tier Account](img/tier-14.png) 

Open "Google Authenticator App", hit Plus sign and scan QR code.
![AWS Free Tier Account](img/tier-15.png) 

You are all set when it comes to so called "root AWS account user"
![AWS Free Tier Account](img/tier-16.png) 

Create a new IAM user "k3s-course-tf"
![AWS Free Tier Account](img/tier-17.png) 

Create "admisnistrators" group and grant "AdministratorAccess" privileges.
![AWS Free Tier Account](img/tier-18.png) 

Add "k3s-course-tf" IAM user to "admisnistrators" group.
![AWS Free Tier Account](img/tier-19.png) 

![AWS Free Tier Account](img/tier-20.png) 

Setup MFA for "k3s-course-tf" IAM user in the same way as it has been already done for "root AWS account".
![AWS Free Tier Account](img/tier-21.png) 

Select MFA device. I would recommend to download "Google Authenticator App" to your cell phone.
![AWS Free Tier Account](img/tier-22.png) 

Open "Google Authenticator App", hit Plus sign and scan QR code.
![AWS Free Tier Account](img/tier-23.png)

Generate "Access keys"
![AWS Free Tier Account](img/tier-24.png) 

Generate "Access keys"
![AWS Free Tier Account](img/tier-25.png) 

![AWS Free Tier Account](img/tier-26.png) 

Store credentials.
![AWS Free Tier Account](img/tier-27.png) 



### Provision EC2 instance in AWS

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
TOKEN_CODE="368139"
token_output=$(aws sts get-session-token \
--serial-number arn:aws:iam::363711084474:mfa/k3s-course-tf \
--token-code ${TOKEN_CODE} \
--profile k3s-course)

# Extract the temporary credentials from the command output
export AWS_ACCESS_KEY_ID=$(echo $token_output | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $token_output | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $token_output | jq -r '.Credentials.SessionToken')

# verify that 
env | grep AWS

cd terraform/
terraform init
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



### Tesing a first deployment via kubectl

```bash
kubectl create deployment k3scourse --image=ghcr.io/benc-uk/python-demoapp:latest --replicas=1 --port 5000
kubectl expose deployment k3scourse --port=8080 --target-port=5000 # --type NodePort

kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: k3scourse
spec:
  rules:
    - http:
        paths:
          - pathType: Prefix
            path: /
            backend:
              service:
                name: k3scourse
                port:
                  number: 8080
EOF


```

Test that security group allows only port specified via telnet or netcat(nc) commnad

```bash
# run this command at EC3 instance in AWS
nc -l -p 10333

# run this commands locally
telnet 1.2.3.4 10333
telnet 1.2.3.4 80

nc -z -v -w2 1.2.3.4 10333
nc -z -v -w2 1.2.3.4 80

awk '/32 host/ { print f } {f=$2}' <<< "$(</proc/net/fib_trie)"
```
