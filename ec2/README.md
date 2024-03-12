## Deploy to ec2
- File need to update
```shell
./ec2/terraform/vars/terraform.tfvars
./ec2/terraform/vars/production.tfvars
```
### Terraform show changes
```shell
terraform plan -var-file="vars/terraform.tfvars"
```

### Terraform apply env production
```shell
terraform apply -var-file="vars/terraform.tfvars" -auto-approve
```

### Terraform destroy
```shell
terraform destroy -var-file="vars/terraform.tfvars" -auto-approve
```