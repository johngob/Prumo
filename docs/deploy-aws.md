# Deploy e Infraestrutura AWS - Prumo (3 Containers)

Este documento descreve como a aplicação **Prumo** está estruturada para deploy na AWS com separação clara de responsabilidades em **3 containers independentes** rodando na mesma task ECS Fargate:
1. **Frontend Web**: SPA Angular 21 servida via Nginx (porta 80).
2. **Backend API**: API NestJS 11 com TypeORM e Swagger (porta 3000).
3. **Banco de Dados**: PostgreSQL 16 Alpine oficial (porta 5432).

---

## 🏛️ Arquitetura de Hospedagem

```
                         Internet
                         │      │
          Porta 80 (Web) │      │ Porta 3000 (API / Swagger)
                         ▼      ▼
        ┌─────────────────────────────────────────────────────────┐
        │                 Task ECS Fargate                        │
        │                                                         │
        │  ┌───────────────────────────────────────────────────┐  │
        │  │           1. Container Frontend (Web)             │  │
        │  │  • Angular 21 compilado servido via Nginx         │  │
        │  │  • Escuta na porta 80 pública                     │  │
        │  │  • Faz proxy reverso transparente de `/api/` para │  │
        │  │    `http://127.0.0.1:3000/api/`                   │  │
        │  └───────────────────────────────────────────────────┘  │
        │                            │                            │
        │                            │ localhost:3000             │
        │  ┌─────────────────────────▼─────────────────────────┐  │
        │  │            2. Container Backend (API)             │  │
        │  │  • API NestJS 11                                  │  │
        │  │  • Swagger interativo em `/api`                   │  │
        │  │  • Conecta no banco via `localhost:5432`          │  │
        │  └─────────────────────────┬─────────────────────────┘  │
        │                            │ localhost:5432             │
        │  ┌─────────────────────────▼─────────────────────────┐  │
        │  │            3. Container Banco de Dados            │  │
        │  │  • PostgreSQL 16 Alpine oficial                   │  │
        │  │  • Porta 5432 interna                             │  │
        │  └───────────────────────────────────────────────────┘  │
        └─────────────────────────────────────────────────────────┘
```

### Por que essa divisão é vantajosa?
- **Isolamento de dependências:** O frontend roda no Nginx (muito mais leve e veloz para arquivos estáticos), enquanto a API roda em Node.js Alpine puro.
- **Proxy reverso integrado:** O Nginx do container Web repassa as chamadas de `/api/` diretamente para o container da API internamente (`127.0.0.1:3000`), eliminando qualquer problema de CORS.
- **Rede unificada sem custo adicional:** Como rodam na mesma Task Fargate com `network_mode = "awsvpc"`, os 3 containers comunicam-se entre si via `localhost`.

---

## 📦 Dockerfiles

Existem dois Dockerfiles dedicados:
- **`src/web/Dockerfile`**: Build do Angular + Nginx com proxy reverso configurado em `src/web/nginx.conf`.
- **`src/api/Dockerfile`**: Build do TypeScript NestJS + runtime Node.js 20 Alpine.

---

## 🚀 Como Provisionar com o Terraform

### 1. Pré-requisitos
- Terraform instalado localmente (`terraform -v`).
- AWS CLI configurado (`aws configure`).

### 2. Configurar Variáveis
1. Acesse o diretório `terraform/`:
   ```powershell
   cd terraform
   Copy-Item terraform.tfvars.example terraform.tfvars
   ```
2. Edite `terraform.tfvars` caso deseje alterar credenciais de banco ou chaves JWT.

### 3. Aplicar o Terraform
```powershell
terraform init
terraform plan
terraform apply -auto-approve
```

O Terraform criará:
- VPC + Subnet Pública + Internet Gateway.
- **2 Repositórios ECR** com política de retenção das 2 últimas imagens (`prumo-app-web` e `prumo-app-api`).
- Log Group no CloudWatch com streams separados para `web`, `api` e `db`.
- Security Group abrindo portas 80 (Web) e 3000 (API/Swagger opcional).
- ECS Cluster e Task Definition com os **3 containers**.

---

## 🔄 Pipeline de CI/CD (GitHub Actions) com Aprovação Manual

O workflow [`.github/workflows/deploy.yml`](../.github/workflows/deploy.yml) é dividido em **dois estágios (jobs)**:

1. **`build-and-push`**:
   - Disparado automaticamente no `push` da branch `main` (ou via `workflow_dispatch`).
   - Realiza login no Amazon ECR.
   - Constrói e envia a imagem do backend (`src/api` -> `prumo-app-api`).
   - Constrói e envia a imagem do frontend (`src/web` -> `prumo-app-web`).

2. **`deploy` (Aprovação Manual Obrigatória)**:
   - Vinculado ao environment `production`.
   - A pipeline pausa e aguarda a revisão/aprovação de um responsável na interface do GitHub Actions.
   - Somente após aprovado, dispara a atualização do serviço ECS Fargate (`aws ecs update-service --force-new-deployment`).

### Como Ativar a Regra de Aprovação Manual no GitHub:
1. No seu repositório no GitHub, acesse: **Settings > Environments**.
2. Clique em **New environment** e crie um ambiente com o nome exatamente: `production`.
3. Na seção **Deployment protection rules**, marque a opção: **Required reviewers**.
4. Adicione o seu usuário (ou o time responsável) como revisor obrigatório e clique em **Save protection rules**.
5. *Pronto!* A partir de agora, qualquer novo build aguardará o clique no botão **"Review deployments -> Approve and deploy"** para entrar no ar.

### Secrets necessários no GitHub:
Acesse no GitHub: **Settings > Secrets and variables > Actions > New repository secret**:

| Secret | Descrição | Exemplo |
| :--- | :--- | :--- |
| `AWS_ACCESS_KEY_ID` | Chave de acesso IAM | `AKIAIOSFODNN7EXAMPLE` |
| `AWS_SECRET_ACCESS_KEY` | Chave secreta IAM | `wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY` |
| `AWS_REGION` | Região da AWS | `us-east-1` |
| `ECR_WEB_REPOSITORY` | *(Opcional, padrão: prumo-app-web)* | `prumo-app-web` |
| `ECR_API_REPOSITORY` | *(Opcional, padrão: prumo-app-api)* | `prumo-app-api` |
| `ECS_CLUSTER_NAME` | *(Opcional, padrão: prumo-app-cluster)* | `prumo-app-cluster` |
| `ECS_SERVICE_NAME` | *(Opcional, padrão: prumo-app-service)* | `prumo-app-service` |

---

## 🌐 Como Acessar a Aplicação

Após a task iniciar:
1. Obtenha o IP público via AWS CLI ou console do ECS.
2. Acesse:
   - **Aplicação Web:** `http://<IP_PUBLICO>` (Porta 80 padrão)
   - **Swagger da API (Direto):** `http://<IP_PUBLICO>:3000/api`
   - **Swagger da API (Via Proxy Web):** `http://<IP_PUBLICO>/api`
