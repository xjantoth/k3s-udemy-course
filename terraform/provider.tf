provider "aws" {
   default_tags {
   tags = {
     Environment = "Course"
     Owner       = "Terraform"
     Project     = "Learning"
     Name        = "k3s-course"
   }
 }
}
