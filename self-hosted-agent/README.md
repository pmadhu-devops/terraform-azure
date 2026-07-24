# Azure DevOps self-hosted agent

This configuration creates an Ubuntu 22.04 VM from the shared Terraform modules and registers it in an Azure DevOps agent pool during first boot.

The bootstrap installs the tools needed to build and deploy the `dockersamples/example-voting-app` sample:

- Docker Engine, Buildx, and Docker Compose
- Git, Python 3, Node.js/npm, and .NET 8 SDK
- Azure CLI and kubectl
- Terraform and Trivy
- Azure Pipelines agent

## Use

1. Copy `terraform.tfvars.example` to `terraform.tfvars`.
2. Set `azure_devops_url`, `azure_devops_pat`, and the agent pool values. The PAT needs Agent Pools read and manage permission.
3. Authenticate to Azure with the Azure CLI or another Terraform-supported method.
4. Run:

```powershell
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

The PAT and VM administrator password are stored in Terraform state because they are rendered into VM custom data. Use a protected remote state backend and treat the state as sensitive. For production, prefer a bootstrap mechanism that retrieves the PAT from a secret store rather than placing it in Terraform variables.

After deployment, verify the VM appears online under **Project settings > Agent pools** in Azure DevOps. The agent service logs are available with `journalctl -u vsts.agent.*` and the bootstrap log is `/var/log/self-hosted-agent-install.log`.

## Agent pool registration troubleshooting

If the bootstrap reports `Agent pool not found`, the agent package is installed but Azure DevOps registration has not completed. In Azure DevOps, open **Organization settings > Agent pools** and copy the exact name of an existing self-hosted pool, or create one such as `voting-app-linux`. The PAT must have **Agent Pools: Read & manage** permission and must belong to the same organization in `azure_devops_url`.

You can finish registration on the existing VM without recreating it:

```bash
cd /opt/azagent
read -rsp 'Azure DevOps PAT: ' AZP_TOKEN; echo
sudo -u azureadmin ./config.sh --unattended \
	--url https://dev.azure.com/your-organization \
	--auth pat \
	--token "$AZP_TOKEN" \
	--pool voting-app-linux \
	--agent docker-voting-agent \
	--replace
unset AZP_TOKEN
sudo ./svc.sh install azureadmin
sudo ./svc.sh start
sudo ./svc.sh status
```

Replace `azureadmin`, the organization URL, pool name, and agent name with the values in `terraform.tfvars`. Do not put the replacement PAT in the command itself. If the pool is project-scoped, use the project URL when registering the agent instead of the organization URL.