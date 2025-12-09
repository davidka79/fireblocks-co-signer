provider "aws" {
  region = var.region
}

provider "awscc" {
  region = var.region
}

data "aws_caller_identity" "current" {}
