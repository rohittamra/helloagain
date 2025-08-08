az login
az ad sp create-for-rbac --name "github-actions-sp" --role Contributor --scopes /subscriptions/353073dd-7939-4943-a19e-ff2a92635367 --sdk-auth
