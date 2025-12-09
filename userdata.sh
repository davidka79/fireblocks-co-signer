#!/bin/bash
sudo su -

# Redirect stdout and stderr to both a log file and the console
exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

# Remove default user and close access to ssh for root
userdel -r ec2-user
rm -rf /root/.ssh/authorized_keys

yum update && yum -y upgrade
# for CloudWatch Agent
yum install -y collectd

### SSH configuration ###
echo "Removing SSH server."
systemctl stop sshd
systemctl disable sshd
yum remove -y openssh-server
echo "SSH service has been removed."
### /SSH configuration ###

### Fireblocks co-signer
INSTALL_DIR="/var/lib/fireblocks"
TARBALL_URL="https://fb-customers-nitro.s3.amazonaws.com/nitro-cosigner-v2.0.2.tar.gz"
TARBALL_NAME="nitro-cosigner-v2.0.2.tar.gz"

echo "Creating installation directory at $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"

cd "$INSTALL_DIR" || exit

echo "Downloading Nitro Cosigner..."
wget -q -O "$TARBALL_NAME" "$TARBALL_URL"

echo "Extracting $TARBALL_NAME..."
tar -xzf "$TARBALL_NAME"

echo "Cleaning up..."
rm -f "$TARBALL_NAME"

echo "Installation complete in $INSTALL_DIR."

s3_bucket_name="${StorageBucketName}"
kms_key_arn="${KmsKeyArn}"
api_tokens=$(aws ssm get-parameter --name "/${ProjectName}/tokens" --with-decryption --query "Parameter.Value" --output text)

# Split the api_tokens into an array
IFS=',' read -ra tokens <<< "$api_tokens"

first_token="$${tokens[0]}"
echo -e "$${first_token}\n$${s3_bucket_name}\n$${kms_key_arn}\n" | bash /var/lib/fireblocks/install.sh --force >/dev/null 2>&1

echo "Waiting for the actual status..."
sleep 60
bash /var/lib/fireblocks/fireblocks/cosigner get-status
bash /var/lib/fireblocks/fireblocks/cosigner list-users

for token in "$${tokens[@]:1}"; do
  echo -e "$${token}\n" | bash /var/lib/fireblocks/fireblocks/cosigner add-user >/dev/null 2>&1
done

echo "Check status status after adding all users..."
sleep 15
bash /var/lib/fireblocks/fireblocks/cosigner get-status
bash /var/lib/fireblocks/fireblocks/cosigner list-users

echo "Installation process completed for all tokens."

### /Fireblocks co-signer
