resource "aws_key_pair" "this" {
  key_name   = var.prefix
  public_key = file(var.ssh_public_key_path)
}

resource "aws_ssm_parameter" "k3s_token" {
    name = "k3s_token"
    value = "empty"
    type = "String"

    lifecycle {
      ignore_changes = [value]
    }
}

resource "aws_iam_role" "put_parameters" {
    name = "put_parameters"
    description = "Role to permit ec2 to put parameters from Parameter Store"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "put_parameters" {
    name = "put_parameters"
    role = aws_iam_role.put_parameters.name
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters",
                "ssm:PutParameters",
                "ssm:PutParameter"
            ],
            "Resource": [
                "${aws_ssm_parameter.k3s_token.arn}"
            ]
        }
        
    ]
}
EOF
}

resource "aws_iam_instance_profile" "k3s_master" {
    name = "k3s_master"
    role = aws_iam_role.put_parameters.name
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

  iam_instance_profile = aws_iam_instance_profile.k3s_master.name

}

data "template_file" "node" {
  template = file("../config/node.sh")

  vars = {
    MASTER_PRIVATE_IPV4 = aws_instance.master.private_ip
    REGION = var.region
  }
}

# K3S Node section
resource "aws_iam_role" "get_parameters" {
    name = "get_parameters"
    description = "Role to permit ec2 to get parameters from Parameter Store"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "get_parameters" {
    name = "get_parameters"
    role = aws_iam_role.get_parameters.name
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters"
            ],
            "Resource": [
                "${aws_ssm_parameter.k3s_token.arn}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "k3s_node" {
    name = "get_parameters"
    role = aws_iam_role.get_parameters.name
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

  iam_instance_profile = aws_iam_instance_profile.k3s_node.name

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

