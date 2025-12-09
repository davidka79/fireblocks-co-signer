resource "aws_security_group" "server" {
  name        = var.project_name
  description = "Security group for the server allowing access specified ingress rules"
  vpc_id      = aws_vpc.main.vpc_id
  tags        = var.tags

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic for unrestricted external communication"
  }

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}
