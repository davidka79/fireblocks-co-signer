# EC2 Fireblocks Co-signer

The Fireblocks Co-signer service enables automated signing and approval using the Fireblocks API.

## Prerequisites

To get started, configure the AWS Parameter Store with a `SecureString`, using the default `aws/ssm` encryption key:

- **Parameter Name:** `/ec2-fireblocks/tokens`
- **Parameter Type:** `SecureString`

If using multiple tokens, ensure they are **comma-separated** without spaces:

**Example:**

```
token1,token2
```

