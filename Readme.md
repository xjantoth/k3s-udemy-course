# K3S Udemy Course

### Course materials can be found at Github
https://github.com/xjantoth/k3s-udemy-course

```bash
git clone https://github.com/xjantoth/k3s-udemy-course
cd k3s-udemy-course
```

![restrictive-terraform-user](img/infra-1-3d.png)
**DISCLAIMER**

Before we embark on this course, it is crucial to be mindful of your AWS resources. Make sure to DELETE ALL YOUR AWS RESOURCES (EC2, S3, SSM, and others) when they are no longer needed. By doing so, you can prevent unexpected charges resulting from forgotten resources like EC2 instances or EBS volumes.

**Prerequisites**

To fully participate in this course, please ensure that you have completed the following steps:

1. Install awscli and Terraform on your machine. These tools will be instrumental throughout the course.
2. [A free coupon is available from my previous courses, which covers the setup of AWS and installation of all required binaries. You can make use of this coupon to access the necessary resources.](https://www.udemy.com/course/learn-devops-helm-helmfile-kubernetes-deployment/?couponCode=588B6996050070A30C8F)
3. In the event that the coupon has expired or the provided link requires an update, please don't hesitate to post a message in this repository, and I will promptly address the issue.
4. As a best practice, it is recommended to create a new email address specifically for this course. This helps to streamline your learning process and keep your course-related communications organized.
5. Prior to beginning the course, please ensure that you have set up an AWS Free Tier account. This account provides access to a range of AWS services within specific usage limits.
6. Safeguarding your AWS passwords is of utmost importance. Consider using password management tools like KeePass to securely store your credentials.
7. Protect your AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY at all times, refraining from sharing them with anyone. When not in use, it is advisable to delete or deactivate these keys to enhance security.
8. Setting up Multi-Factor Authentication (MFA) is highly recommended to add an extra layer of security to your AWS account.
9. Lastly, please ensure that the date and time settings on your computer are accurate, as this can impact various aspects of your AWS environment.

Note:
It is worth noting that the AWS Free Tier account supports three regions by default: Virginia, Oregon, and Ohio.

### Table of Content

1. [Introduction](content-md/Introduction.md)
1. [Setup AWS Free Tier Account](content-md/Setup-AWS-Free-Tier-Account.md)
1. [Create Web UI admin IAM user](content-md/Create-Web-UI-admin-IAM-user.md)
1. [MFA enforced on CLI level](content-md/MFA-enforced-on-CLI-level.md)
1. [Create terraform IAM user](content-md/Create-terraform-IAM-user.md)
1. [Create S3 bucket](content-md/Create-S3-bucket.md)
1. [Setting up S3 as terraform backend](content-md/Setting-up-S3-as-terraform-backend.md)
1. [Demonstrate creation of IAM users via Terraform](content-md/Demonstrate-creation-of-IAM-users-via-Terraform.md)
1. [Writing terraform infrastructure code for K3S cluster](content-md/Writing-terraform-infrastructure-code-for-K3S-cluster.md)

1. [Deploy AWS infrastructure via Terraform](content-md/Deploy-AWS-infrastructure-via-Terraform.md)

1. [Testing a first deployment via kubectl and a bit of Helm](content-md/Testing-a-first-deployment-via-kubectl.md)
1. [Github action CICD pipeline to run Terraform](content-md/Github-action-CICD-pipeline-to-run-Terraform.md)
2. [Clean UP and AWS Billing](content-md/Clean-UP-and-AWS-Billing.md)
