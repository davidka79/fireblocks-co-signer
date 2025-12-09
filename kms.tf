resource "aws_kms_key" "fireblocks_nitro_cosigner" {
  description             = "Fireblocks key for encrypting Co-signer's MPC keyshares."
  enable_key_rotation     = true
  deletion_window_in_days = 7

  policy = templatefile("policies/KmsResource.json", {
    ServerRoleArn = aws_iam_role.server.arn
    Pcr8Value     = var.pcr8_value
    AccountId     = data.aws_caller_identity.current.account_id
  })

  tags = merge(
    tomap({
      Name = var.project_name
    }),
    var.tags
  )
}

resource "aws_kms_alias" "fireblocks_nitro_cosigner" {
  name          = "alias/${var.project_name}"
  target_key_id = aws_kms_key.fireblocks_nitro_cosigner.key_id
}
