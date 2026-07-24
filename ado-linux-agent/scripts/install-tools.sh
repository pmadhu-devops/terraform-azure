#!/bin/bash
set -euo pipefail

exec > >(tee /var/log/custom-data.log) 2>&1
# This script installs common devops tools on Ubuntu 22.04.
# It is intended to be used as cloud-init/custom_data (run as root on first boot). After check this command "cloud-init status" -- running/done

# Prevent interactive prompts
export DEBIAN_FRONTEND=noninteractive

apt_update() {
  apt-get update -y
}

install_utilities() {
  apt-get install -y curl wget unzip jq net-tools tree ca-certificates gnupg lsb-release software-properties-common apt-transport-https
}

install_java_maven() {
  apt-get install -y openjdk-11-jdk maven
}

install_docker() {
  apt-get install -y docker.io
  systemctl enable --now docker
  # allow the admin user to use docker if present
  if id -u ubuntu &>/dev/null; then
    usermod -aG docker ubuntu || true
  fi
  # also add specified admin user to docker group if present
  if id -u adminmadhu &>/dev/null; then
    usermod -aG docker adminmadhu || true
  fi
}

install_hashicorp_tools() {
  # Install HashiCorp repo for Terraform & Packer
  curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list
  apt-get update -y
  apt-get install -y terraform
}

install_azure_cli() {
  curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/microsoft-archive-keyring.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list
  apt-get update -y
  apt-get install -y azure-cli
}

# install_aws_cli() {
#   # Install AWS CLI v2
#   tmpdir=$(mktemp -d)
#   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$tmpdir/awscliv2.zip"
#   unzip "$tmpdir/awscliv2.zip" -d "$tmpdir"
#   "$tmpdir/aws/install" --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
#   rm -rf "$tmpdir"
# }

# install_ansible() {
#   apt-get install -y ansible
#   # Disable host_key_checking
#   mkdir -p /etc/ansible
#   cat >/etc/ansible/ansible.cfg <<'EOF'
# [defaults]
# host_key_checking = False

# EOF
#   # Also set environment variable system-wide
#   echo 'export ANSIBLE_HOST_KEY_CHECKING=False' > /etc/profile.d/ansible-hostkey.sh
#   chmod 0644 /etc/profile.d/ansible-hostkey.sh
# }

install_trivy() {
  curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo sh -s -- -b /usr/local/bin
}

cleanup() {
  apt-get clean
  rm -rf /var/lib/apt/lists/*
}

main() {
  apt_update
  install_utilities
  install_java_maven
  install_docker
  install_hashicorp_tools
  install_azure_cli
#   install_aws_cli
#   install_ansible
  install_trivy
  cleanup
}

main "$@"
