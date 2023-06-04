resource "aws_key_pair" "this" {
  key_name   = var.prefix
  public_key = file(var.ssh_public_key_path)
}

resource "aws_instance" "this" {
  ami           = var.ami_image
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.this.id]
  key_name        = aws_key_pair.this.key_name

  # Notice that User Data Shell script will be copied:
  # /bin/bash /var/lib/cloud/instance/scripts/part-001
  user_data = file("../config/initial.sh")
  # user_data = "${local.local_user_data}"

  # placement_group = aws_placement_group.partition.id

  # iam_instance_profile = aws_iam_instance_profile.instance_profile.name


}

output "ssh_command" {
  description = "Execute this SSH command to connect to a EC2 in AWS"
  value       = "ssh -i ~/.ssh/k3s-course ubuntu@${aws_instance.this.public_ip}"
  # sensitive = true
}

