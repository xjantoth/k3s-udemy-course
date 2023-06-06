terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.1.0"
    }
  }
  backend "s3" {
    bucket = "k3scourse"
    key    = "tf-statefiles/dev/terraform-dev.tfstate"
    region = "us-east-1"
  }
}

