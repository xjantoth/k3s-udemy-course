### Create terraform IAM user

Navigate to `Security Credentials` section under `k3s-restrictive-no-mfa` IAM user and click to create new `Access key`. Choose `Command Line Interface` and checkbox at the bottom. Finally click `Next`.
![restrictive-terraform-user](../img/rest-1.png) 


Set some `Description tag value`.
![restrictive-terraform-user](../img/rest-2.png) 

Copy `Access key` and `Secret access key`. Download `.csv file` with credentials and never share with anyone.
![restrictive-terraform-user](../img/rest-3.png) 

Check active `Access Keys`
![restrictive-terraform-user](../img/rest-4.png)

Configure AWS CLI profile for `k3s-restrictive-no-mfa` IAM user. The profile name can be anything but for the sake of continuity let's use name: `k3s-restrictive-no-mfa`

```bash
[arch:k3s-udemy-course master()U] aws configure --profile k3s-restrictive-no-mfa
AWS Access Key ID [None]: AKIAVJLW6W65O6Q223ZC
AWS Secret Access Key [None]: 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
Default region name [None]: us-east-1
Default output format [None]:
```
![restrictive-terraform-user](../img/rest-5.png) 
