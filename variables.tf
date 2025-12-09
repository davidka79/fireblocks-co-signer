variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "Specifies the AWS Region for resource deployment, determining the geographical area and data residency."
}

variable "project_name" {
  type        = string
  default     = "fireblocks-cosigner-project"
  description = "Identifies the project within AWS, used for resource categorization and management."
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default     = []
  description = "List of network ingress rules for configuring access to the host."
}

variable "tags" {
  type = map(string)
  default = {
    Project = "fireblocks-co-signer"
    Managed = "IAC"
  }
  description = "Key-value pairs assigned as tags to the resource for identification and organization."
}

variable "instance_type" {
  type        = string
  default     = "m5.xlarge"
  description = "Specifies the type of EC2 instance to be used, defining compute, memory, and networking capacity."
}

variable "storage_bucket_name" {
  type        = string
  default     = "fireblocks-co-signer-storage-kPZS5BuY2p1-eu-central-1"
  description = "The name of the S3 bucket used for storing cosigner-related data."
}

variable "pcr8_value" {
  type        = string
  default     = "da1d9eca20ce98ab4fdbc51f8e5a2307fd4c61829b7d8bff40976cd6676862c8f3476ff4bdd0f65ecf4a48d6eb3099a8"
  description = "The expected PCR8 value for verifying the instance's secure boot state."
}

## aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-2.0.*-x86_64-gp2" --query "Images[?contains(Name, 'amzn2-ami-hvm') && Architecture=='x86_64'] | reverse(sort_by(@, &CreationDate))[:5].{Name:Name, ImageId:ImageId}"
variable "ami" {
  type        = string
  default     = "ami-0592c673f0b1e7665"
  description = "The Amazon Machine Image (AMI) ID for Amazon Linux 2023, designed for instances with Nitro capabilities."
}
