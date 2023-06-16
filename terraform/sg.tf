resource "aws_security_group" "this" {
  name        = "${var.prefix}-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.default.id


  dynamic "ingress" {
    for_each = var.allowed_ports

    content {
      description = "Allow TCP/SSH traffic"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      # Please restrict your ingress to only necessary IPs and ports.
      # Opening to 0.0.0.0/0 can lead to security vulnerabilities.

      cidr_blocks = ["0.0.0.0/0"] # add a CIDR block here
      # security_groups = list(var.alb_security_group_id)
    }
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # or "udp" or "icmp" depending on the desired protocol
    description = "Allow inter-VPC traffic"
    #security_groups = [aws_security_group.destination.id]  # Security group in the destination VPC
    self = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


}
