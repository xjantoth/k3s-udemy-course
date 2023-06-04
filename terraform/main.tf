data "aws_vpc" "default" {
  default = "true"
}

data "aws_availability_zones" "default" {
  state = "available"
}
