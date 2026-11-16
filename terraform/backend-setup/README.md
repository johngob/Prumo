# Setup do Bucket S3 para o Terraform State (Backend Remoto)

Este subdiretório contém o código Terraform utilizado para criar e gerenciar o bucket S3 onde o arquivo de estado (`terraform.tfstate`) do projeto Prumo é armazenado com segurança.

## Recursos Criados
- **Bucket S3:** `prumo-app-tfstate-522348935231` (Região: `us-east-1`)
- **Versionamento:** Habilitado (`aws_s3_bucket_versioning`), permitindo recuperar versões anteriores do tfstate em caso de erro.
- **Criptografia:** `AES256` habilitada por padrão (`aws_s3_bucket_server_side_encryption_configuration`).
- **Bloqueio de Acesso Público:** 100% ativado (`aws_s3_bucket_public_access_block`).
- **Proteção contra Exclusão Acidental:** `prevent_destroy = true`.

## Como Foi Executado
```bash
cd terraform/backend-setup
terraform init
terraform apply -auto-approve
```
