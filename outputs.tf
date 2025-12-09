output "output" {
  value = {
    server_arn = aws_instance.server.arn
    server_ip  = aws_instance.server.private_ip
    server_url = "https://${var.region}.console.aws.amazon.com/ec2/home?region=${var.region}#InstanceDetails:instanceId=${aws_instance.server.id}"
  }
}
