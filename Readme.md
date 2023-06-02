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

```bash
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_REGION="us-west-2"

``` 

