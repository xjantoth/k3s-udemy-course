resource "aws_key_pair" "this" {
  key_name   = var.prefix
  public_key = file(var.ssh_public_key_path)
}

resource "aws_instance" "master" {
  ami           = var.ami_image
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.this.id]
  key_name        = aws_key_pair.this.key_name

  # Notice that User Data Shell script will be copied:
  # /bin/bash /var/lib/cloud/instance/scripts/part-001
  user_data = file("../config/master.sh")
  # user_data = "${local.local_user_data}"

  # placement_group = aws_placement_group.partition.id

  # iam_instance_profile = aws_iam_instance_profile.instance_profile.name

}

data "external" "join_cmd" {
  # count   = "${var.enabled == "true" ? 1 : 0}"
  program = ["python", "../config/get_k3s_token.py"]

  query = {
    host = aws_instance.master.public_ip
    ssh_private_key_path = "~/.ssh/k3s-course"
  }
  depends_on = [aws_instance.master]
}


data "template_file" "node" {
  template = file("../config/node.sh")

  vars = {
    MASTER_PRIVATE_IPV4 = aws_instance.master.private_ip
    K3S_TOKEN = data.external.join_cmd.result.cmd
  }
}

resource "aws_instance" "node" {
  ami           = var.ami_image
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.this.id]
  key_name        = aws_key_pair.this.key_name

  # Notice that User Data Shell script will be copied:
  # /bin/bash /var/lib/cloud/instance/scripts/part-001
  user_data = data.template_file.node.rendered
  # user_data = "${local.local_user_data}"

  # placement_group = aws_placement_group.partition.id

  # iam_instance_profile = aws_iam_instance_profile.instance_profile.name

}

output "ssh_command_master" {
  description = "Execute this SSH command to connect to a EC2 in AWS (K3S master)"
  value       = "ssh -i ~/.ssh/k3s-course ubuntu@${aws_instance.master.public_ip}"
  # sensitive = true
}

output "ssh_command_node" {
  description = "Execute this SSH command to connect to a EC2 in AWS (K3S node)"
  value       = "ssh -i ~/.ssh/k3s-course ubuntu@${aws_instance.node.public_ip}"
  # sensitive = true
}

