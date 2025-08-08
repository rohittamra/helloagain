az login
az account set --subscription "<YOUR_SUBSCRIPTION_ID_OR_NAME>"

# in your terraform directory:
terraform init
terraform plan -out=tfplan
terraform apply tfplan
