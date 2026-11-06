# Guia de Criação de Credenciais AWS (IAM)

Este guia orienta a criação de um usuário programático no **AWS IAM** com permissões para provisionar a infraestrutura (Terraform), publicar imagens no ECR e gerenciar o cluster ECS Fargate.

---

## 🔑 Passo a Passo no Console da AWS

### Passo 1: Acessar o AWS IAM
1. Faça login no [Console da AWS](https://console.aws.amazon.com/).
2. Na barra de busca superior, digite **IAM** e clique no serviço correspondente.

---

### Passo 2: Criar um Usuário IAM
1. No menu lateral esquerdo, clique em **Users** (Usuários) > botão **Create user** (Criar usuário).
2. **User name:** digite um nome identificador, por exemplo: `prumo-deployer`.
3. Deixe desmarcada a opção *"Provide user access to the AWS Management Console"* (este usuário precisa apenas de acesso via CLI/programático).
4. Clique em **Next** (Próximo).

---

### Passo 3: Definir as Permissões
1. Na tela de permissões, selecione **Attach policies directly** (Anexar políticas diretamente).
2. Na barra de busca de permissões, adicione as seguintes políticas gerenciadas pela AWS:
   - `AdministratorAccess` *(Recomendado para primeiro provisionamento de infraestrutura completa VPC + ECR + ECS + IAM Roles via Terraform)*.
   *(Ou, se preferir permissões restritas: `AmazonECS_FullAccess`, `AmazonEC2ContainerRegistryFullAccess`, `AmazonVPCFullAccess`, `IAMFullAccess`, `CloudWatchLogsFullAccess`)*.
3. Clique em **Next** e depois em **Create user** (Criar usuário).

---

### Passo 4: Gerar as Chaves de Acesso (Access Key & Secret Key)
1. Na lista de usuários do IAM, clique no usuário recém-criado (`prumo-deployer`).
2. Acesse a aba **Security credentials** (Credenciais de segurança).
3. Role até a seção **Access keys** e clique em **Create access key** (Criar chave de acesso).
4. Selecione o caso de uso: **Command Line Interface (CLI)**.
5. Marque a caixa de confirmação *"I understand the above recommendation..."* e clique em **Next**.
6. (Opcional) Dê uma descrição como: `Chave para deploy do Prumo`.
7. Clique em **Create access key**.

---

### Passo 5: Salvar as Chaves
Na tela de conclusão, você verá:
- **Access key ID:** uma sequência de letras maiúsculas e números começando com `AKIA...`.
- **Secret access key:** uma chave longa clicando em **Show** (Mostrar).

> [!IMPORTANT]
> **Atenção:** Clique no botão **Download .csv file** ou copie e guarde ambas em um local seguro. A Secret Key nunca mais poderá ser visualizada após fechar esta tela.

