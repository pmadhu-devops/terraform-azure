rg_name  = "rg-vote"
location = "centralindia"

tags = {
  Environment = "dev"
  Purpose     = "azure-devops-practice"
}
# Acr Values
acr_name = "samplevoteacr01"
acr_sku  = "Standard"

vnet_name     = "self-hosted-agent-vnet"
address_space = ["10.10.0.0/16"]
subnets = {
  agent = {
    address_prefixes = ["10.10.1.0/24"]
  }
}
subnet_name = "agent"

nsg_name = "self-hosted-agent-nsg"
security_rules = {
  ssh = {
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# VM Details
vm_name        = "self-hosted-agent-vm"
vm_size        = "Standard_B2ms"
admin_username = "adminmadhu"
# admin_password is set via TF_VAR_ADMIN_PASSWORD environment variable
vm_tags = {
  Purpose = "azure-devops-voting-app"
}

azure_devops_url = "https://dev.azure.com/madhu-devops-org"
# azure_devops_pat is set via TF_VAR_AZURE_DEVOPS_PAT environment variable
azure_devops_pool       = "ado-agent-pool"
azure_devops_agent_name = "ado-agent"