variable "ami_image" {
  description = "AWS AMI image id e.g. ami-0ff8a91507f77f867"
  type        = string
}

variable "instance_type" {
  description = "AWS instance type e.g. t3.micro"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Local path to SHH public key e.g. /some/path/public_key.pub"
  type        = string
}

variable "prefix" {
  description = "General prefix name used withing this codebase"
  type        = string
}

variable "user_data_script_path" {
  description = "Local path to user_data script  e.g. config/initial.sh"
  type        = string
}

variable "allowed_ports" {
  description = "Allowed TCP ports e.g. [...]"
  type        = list(number)
}
