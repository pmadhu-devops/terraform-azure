#!/bin/bash
set -euo pipefail

exec > >(tee /var/log/self-hosted-agent-install.log) 2>&1
export DEBIAN_FRONTEND=noninteractive

AGENT_USER="${admin_username}"
AZP_URL="${azure_devops_url}"
AZP_TOKEN="${azure_devops_pat}"
AZP_POOL="${azure_devops_pool}"
AZP_AGENT_NAME="${azure_devops_agent_name}"
AGENT_VERSION="${azure_devops_agent_version}"
AGENT_DIR="/opt/azagent"

apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl git gnupg jq lsb-release unzip python3 python3-pip

# Install Docker Engine, Buildx, and Compose from Docker's supported repository.
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" > /etc/apt/sources.list.d/docker.list
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker

# Install runtimes used by the voting app and common pipeline tasks.
curl -fsSL https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -o /tmp/packages-microsoft-prod.deb
dpkg -i /tmp/packages-microsoft-prod.deb
rm /tmp/packages-microsoft-prod.deb
apt-get update -y
apt-get install -y dotnet-sdk-8.0 nodejs npm

# Install Azure CLI.
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install kubectl for the sample's Kubernetes deployment path.
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' > /etc/apt/sources.list.d/kubernetes.list
apt-get update -y
apt-get install -y kubectl

# Install Terraform for infrastructure stages and Trivy for image scanning.
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list
apt-get update -y
apt-get install -y terraform
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin

if ! id -u "$AGENT_USER" >/dev/null 2>&1; then
  useradd --create-home --shell /bin/bash "$AGENT_USER"
fi
usermod -aG docker "$AGENT_USER"

mkdir -p "$AGENT_DIR"
chown -R "$AGENT_USER":"$AGENT_USER" "$AGENT_DIR"
cd "$AGENT_DIR"

download_agent() {
  local agent_archive="vsts-agent-linux-x64-$AGENT_VERSION.tar.gz"
  local download_urls=(
    "https://download.agent.dev.azure.com/agent/$AGENT_VERSION/$agent_archive"
    "https://vstsagentpackage.azureedge.net/agent/$AGENT_VERSION/$agent_archive"
  )

  for download_url in "$${download_urls[@]}"; do
    if curl --fail --location --retry 5 --retry-all-errors --connect-timeout 15 \
      "$download_url" -o agent.tar.gz; then
      return 0
    fi
    rm -f agent.tar.gz
  done

  echo "Unable to download Azure Pipelines agent version $AGENT_VERSION" >&2
  return 1
}

download_agent
tar -xzf agent.tar.gz
rm agent.tar.gz
chown -R "$AGENT_USER":"$AGENT_USER" "$AGENT_DIR"

runuser -u "$AGENT_USER" -- "$AGENT_DIR/config.sh" \
  --unattended \
  --url "$AZP_URL" \
  --auth pat \
  --token "$AZP_TOKEN" \
  --pool "$AZP_POOL" \
  --agent "$AZP_AGENT_NAME" \
  --replace \
  --acceptTeeEula

./svc.sh install "$AGENT_USER"
./svc.sh start

unset AZP_TOKEN
apt-get clean
rm -rf /var/lib/apt/lists/*