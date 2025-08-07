az login
az ad sp create-for-rbac --name "github-actions-sp" --role Contributor --scopes /subscriptions/88393e33-fcbe-49c7-82ac-8e7cac49eda3 --sdk-auth
