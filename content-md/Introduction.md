# Introduction


### Course materials can be found at Github
https://github.com/xjantoth/k3s-udemy-course


![restrictive-terraform-user](img/infra-1-3d.png)

### !!! DISCLAIMER

Make sure to **DELETE ALL YOUR AWS RESOURCES** (ec2, s3, ssm, ...) when not used.
Avoid any unexpected charges simply because of forgotten EC2, EBS or any other resources.

### Prerequisites

- install awscli, terraform
- [Free Coupon from my previous courses on how to setup AWS, and install all required binaries.](https://www.udemy.com/course/learn-devops-helm-helmfile-kubernetes-deployment/?couponCode=588B6996050070A30C8F)
- anyone can post a message in case the coupon has been expired and I would forget to update a link here in this repo

- recommend to create a new email address (just for the sake of this course)
- [setup AWS Free Tier account](https://portal.aws.amazon.com/billing/signup?type=enterprise#/start/email)
- `k3scourse@gmail.com` (this email is taken by me)
- keep your passwords to AWS safe e.g. keepass, ...
- never share `AWS_ACCESS_KEY_ID` or `AWS_SECRET_ACCESS_KEY` with anyone (delete/deactivate whenever not used)
- setup MFA authentication (recommended)
- make sure that `datetime` is accurate at your computer

Note: 3 AWS regions are supported out of a box for AWS Free tier account (Virginia, Oregon, Ohio)
