# Clean UP and AWS Billing

#### Destroy your infrastructure to avoid unneceassary expenxes

```bash
export AWS_DEFAULT_PROFILE=k3s-restrictive-no-mfa
cd terraform/
terraform destroy
```

#### Remove AWS IAM users if created via terraform

```bash
export AWS_DEFAULT_PROFILE=k3s-root
cd tf-root/
terraform destroy
```

#### Manually remove/delete S3 bucket

Remove your S3 bucket
