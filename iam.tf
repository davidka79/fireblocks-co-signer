resource "aws_iam_role" "server" {
  name                 = "${var.region}-${var.project_name}"
  path                 = "/"
  description          = "Allows Fireblocks EC2 instances to interact with AWS services securely."
  max_session_duration = 3600
  assume_role_policy   = file("${path.module}/policies/Ec2Trust.json")

  tags = var.tags
}

resource "aws_iam_instance_profile" "server" {
  name = "${var.region}-${var.project_name}"
  role = aws_iam_role.server.name
}

resource "aws_iam_policy" "server" {
  name        = "${var.region}-${var.project_name}"
  description = "IAM policy for the Fireblocks server."
  policy = templatefile(
    "policies/Server.json",
    {
      FireblocksNitroCosignerKmsKeyArn = aws_kms_key.fireblocks_nitro_cosigner.arn,
      StorageBucketArn                 = aws_s3_bucket.storage_bucket.arn
      Region                           = var.region
      AccountId                        = data.aws_caller_identity.current.account_id
      ProjectName                      = var.project_name
    }
  )

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "server" {
  role       = aws_iam_role.server.name
  policy_arn = aws_iam_policy.server.arn
}

resource "aws_iam_role_policy_attachment" "ssm_managed" {
  role       = aws_iam_role.server.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  #  role       = aws_iam_role.server.name
  #  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.region}-SsmManagedInstanceMinimal"
}
