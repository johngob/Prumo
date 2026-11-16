# Projeto Acadêmico - ECS Fargate (Aplicação + Banco)

Este projeto provisiona uma infraestrutura na AWS usando **Terraform nativo** com foco em **baixo custo** (sem ALB, sem NAT Gateway e sem volumes EFS), ideal para laboratórios e apresentações acadêmicas com orçamento controlado.

---

## 🏛️ Arquitetura

- **VPC & Rede:**
  - 1 VPC (`10.0.0.0/16`)
  - 1 Subnet Pública com Internet Gateway (IGW) e rota pública.
- **ECS Fargate (Single Task):**
  - **1 Task Definition** contendo **2 containers**:
    1. **Aplicação:** exposta diretamente na porta configurada (padrão: 80).
    2. **Banco de Dados:** porta interna (padrão: 5432).
  - **Comunicação App ⇄ Banco:** Como rodam na mesma task (`network_mode = awsvpc`), a aplicação conecta-se ao banco diretamente via `localhost:<porta>`.
  - **Security Group:** Apenas a porta da aplicação fica aberta para a internet (`0.0.0.0/0`). O banco não recebe tráfego externo.
- **Custo:** Praticamente \$0 em repouso. Em execução, consome apenas centavos por hora (fração de vCPU/RAM no Fargate).

---

## 📂 Estrutura de Arquivos

```text
proj-le/
├── main.tf                    # Orquestração dos módulos
├── variables.tf               # Variáveis globais com valores padrão
├── outputs.tf                 # Saídas informativas e comando para obter o IP
├── terraform.tfvars.example   # Exemplo de customização de imagens e senhas
├── README.md                  # Documentação do projeto
└── modules/
    ├── network/               # Módulo de Rede pura
    │   ├── main.tf            # VPC, Subnet, IGW, Route Table
    │   ├── variables.tf
    │   └── outputs.tf
    └── ecs/                   # Módulo de Computação
        ├── main.tf            # Cluster ECS, Task Definition, ECS Service
        ├── iam.tf             # Role de execução e policy padrão ECS
        ├── sg.tf              # Security Group
        ├── variables.tf
        └── outputs.tf
```

---

## 🚀 Como Executar

### 1. Pré-requisitos
- Terraform instalado (`terraform -v`).
- AWS CLI configurado com suas credenciais (`aws configure`).

### 2. Customizar Variáveis (Opcional)
Se desejar alterar as imagens Docker, credenciais do banco ou porta:
1. Copie o arquivo de exemplo:
   ```powershell
   Copy-Item terraform.tfvars.example terraform.tfvars
   ```
2. Edite o `terraform.tfvars` com suas informações.

### 3. Inicializar e Aplicar
```powershell
terraform init
terraform plan
terraform apply -auto-approve
```

---

## 🌐 Como Acessar a Aplicação

A infraestrutura conta com sincronização dinâmica via **DuckDNS** (subdomínio fixo gratuito através do container `duckdns-updater` integrado na task):

### Acesso Direto com Domínio Fixo
- **Aplicação Web:** `http://<duckdns_domain>.duckdns.org` (ex: `http://prumo-ind.duckdns.org`)
- **Documentação Swagger (API):** `http://<duckdns_domain>.duckdns.org:3000/api`

---

### Opção Alternativa: Via IP Público Dinâmico
Como não utilizamos Load Balancer para economizar custos, a task Fargate também possui um IP público temporário atribuído pela AWS:

#### Via Console AWS
1. Acesse o **Amazon ECS** no console da AWS.
2. Clique no cluster `prumo-app-cluster` > aba **Tasks**.
3. Clique na task que está no estado `RUNNING`.
4. Na seção **Network**, copie o valor de **Public IP**.
5. Abra no navegador: `http://<PUBLIC_IP>` (Porta 80 padrão).

#### Via AWS CLI (PowerShell)
Execute o comando retornado pelo output `how_to_get_public_ip` do Terraform:
```powershell
$taskArn = aws ecs list-tasks --cluster prumo-app-cluster --service-name prumo-app-service --query 'taskArns[0]' --output text
$eniId = aws ecs describe-tasks --cluster prumo-app-cluster --tasks $taskArn --query 'tasks[0].attachments[0].details[?name==`networkInterfaceId`].value' --output text
$publicIp = aws ec2 describe-network-interfaces --network-interface-ids $eniId --query 'NetworkInterfaces[0].Association.PublicIp' --output text

Write-Host "URL da Aplicação: http://$publicIp"
```

---

## 🧹 Destruição dos Recursos (Evitar Custos!)

Assim que finalizar o teste ou apresentação da aula, destrua todos os recursos para não haver cobranças adicionais:
```powershell
terraform destroy -auto-approve
```

