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


# Copy a copy of SSH public key to terraform/ folder
cp ~/.ssh/k3s-course.pub .

```

Check get-caller-identity

```bash
aws sts get-caller-identity --profile k3s-admin
{
    "UserId": "AIDAVJLW6W65NFGEHZ3RF",
    "Account": "363711084474",
    "Arn": "arn:aws:iam::363711084474:user/k3s-admin"
}

```
