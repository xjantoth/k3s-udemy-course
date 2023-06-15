# K3S Udemy Course

### Course materials can be found at Github

https://github.com/xjantoth/k3s-udemy-course

### !!! Disclaimer

Make sure to **DELETE ALL YOUR AWS** resources when you are not using it.
Avoid any unexpected charges simply because of forgotten EC2, EBS or any other resources. 

### Prerequisites

- install awscli, terraform
- Free Coupon from my previous courses on how to setup AWS, and install all required binaries.
- https://www.udemy.com/course/learn-devops-helm-helmfile-kubernetes-deployment/?couponCode=588B6996050070A30C8F
- anyone can post a message in case the coupon has been expired and I would forget to update a link here in this repo

- recommend to create a new email address (just for the sake of this course)
- setup AWS Free Tier account (https://portal.aws.amazon.com/billing/signup?type=enterprise#/start/email)
- `k3scourse@gmail.com` (this email is taken by me)
- keep your passwords to AWS safe e.g. keepass, ...
- never share `AWS_ACCESS_KEY_ID` or `AWS_SECRET_ACCESS_KEY` with anyone (delete/deactivate whenever not used)
- setup MFA authentication (recommended)
- make sure that `datetime` is accurate at your computer

Note: 3 AWS regions are supported out of a box for AWS Free tier account (Virginia, Oregon, Ohio)


Table of Content

1. [Setup AWS Free Tier Account](content-md/Setup-AWS-Free-Tier-Account.md)
2. [Create terraform IAM user](content-md/Create-terraform-IAM-user.md)
3. [Create Web UI admin IAM user](content-md/Create-Web-UI-admin-IAM-user.md)
4. [Create S3 bucket](content-md/Create-S3-bucket.md)
5. [Demonstrate creation of IAM users via Terraform](content-md/Demonstrate-creation-of-IAM-users-via-Terraform.md)
6. [Setting up S3 as terraform backend](content-md/Setting-up-S3-as-terraform-backend.md)
7. [Writing terraform code for 2 AWS EC2 instances](content-md/Writing-terraform-code-for-2-AWS-EC2-instances.md)
8. [MFA enforced on CLI level](content-md/MFA-enforced-on-CLI-level.md)
9. [Testing a first deployment via kubectl](content-md/Testing-a-first-deployment-via-kubectl.md)


