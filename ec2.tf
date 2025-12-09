locals {
  user_data_vars = {
    Region            = var.region
    ProjectName       = var.project_name
    StorageBucketName = aws_s3_bucket.storage_bucket.bucket
    KmsKeyArn         = aws_kms_key.fireblocks_nitro_cosigner.arn
  }
}

resource "aws_instance" "server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.server.id]
  user_data                   = templatefile("userdata.sh", local.user_data_vars)
  user_data_replace_on_change = false
  disable_api_termination     = true
  iam_instance_profile        = aws_iam_instance_profile.server.name

  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tags = var.tags

  subnet_id = aws_subnet.private.id

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 10
    volume_type           = "gp2"
    tags                  = var.tags
  }

  enclave_options {
    enabled = true
  }
}
