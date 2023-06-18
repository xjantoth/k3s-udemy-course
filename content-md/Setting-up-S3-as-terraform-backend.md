### Setting up S3 as terraform backend

Here are two examples that demonstrate how to use AWS S3 as a storage solution for the Terraform state file. Pay attention to the backend code block. In this example, the `bucket` name is set as `k3scourse`, which was created in one of the previous videos. The `key` parameter is optional and can be named according to your preference. To adhere to a common naming convention when working with multiple environments, we have chosen the format `tf-statefiles/dev/terraform-dev.tfstate`. Make sure to specify the `region` as us-east-1, which is consistent throughout the entire process.

```bash
terraform {
  required_version = ">= 0.15"
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "5.1.0"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.2.0"
    }
  }
  backend "s3" {
    bucket = "k3scourse"
    key    = "tf-statefiles/dev/terraform-dev.tfstate"
    region = "us-east-1"
  }
}

```

The second codeblock is used to automatically create two IAM users `k3s-admin` and `k3s-restrictive-no-mfa`. These are our well known IAM users that have been created and configured manually. However, there is also an existing terraform code even for this actions that can be reused and it saves some time when setting up a completely new environment. Now, the only difference comparing to the first example is `key` keyword. Since, these would be two completely different codebases, the terraform states must be stored separately. This can be achieved by specifying a different logical path `tf-statefiles/tf-root/tf-root.tfstate`.

```bash
terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.1.0"
    }
  }
  backend "s3" {
    bucket = "k3scourse"
    key    = "tf-statefiles/tf-root/tf-root.tfstate"
    region = "us-east-1"
  }
}
```
