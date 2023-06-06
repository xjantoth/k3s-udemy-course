# exclude from .gitignore
ami_image = "ami-0efd657a42099f98f" # Ubuntu 20.04
instance_type = "t3.micro"
ssh_public_key_path = "k3s-course.pub"
prefix = "k3s-course"
user_data_script_path = "../config/inital.sh"
allowed_ports = [22, 80, 6443, 443]
