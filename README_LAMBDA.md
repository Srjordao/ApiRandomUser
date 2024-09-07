# Documentação para Configuração da Função AWS Lambda e Integração com GitHub

## Visão Geral

Esta documentação descreve o processo de configuração de uma função AWS Lambda que aciona um workflow do GitHub em resposta a eventos de push, registra mensagens no CloudWatch Logs e lida com erros e exceções.

## Passos

1. Configurar um Webhook no GitHub no repo 1 para enviar eventos de push para a AWS Lambda.
2. Criar uma API no API Gateway para expor um endpoint HTTP que o webhook do GitHub vai chamar.
3. Criar uma função Lambda que será chamada pela API Gateway para processar o evento de push.
4. Adicionar Layers à função Lambda para incluir dependências.
5. Configurar o GitHub Actions no repo 2 para executar os testes automaticamente quando for acionado.
6. Concluir a configuração do Webhook e monitorar a execução.

## 1. Configurar o Webhook no GitHub (repo 1)

O Webhook será responsável por notificar o AWS quando um push acontecer.

1. Vá para o repo 1 no GitHub.
2. Navegue até **Settings > Webhooks > Add webhook**.
3. Preencha os campos como segue:
   - **Payload URL**: Isso será o endpoint da sua API Gateway (que criaremos nos próximos passos). Deixe esse campo vazio por agora, até termos o URL da API.
   - **Content Type**: Selecione `application/json`.
   - **Which events would you like to trigger this webhook?**: Selecione `Just the push event` para acionar a Lambda somente quando ocorrer um push.
4. Salve o Webhook (você precisará voltar para completar isso com o Payload URL da API Gateway no final do processo).

## 2. Criar uma API no AWS API Gateway

O AWS API Gateway cria um endpoint público que receberá os eventos do Webhook e passará esses eventos para a Lambda.

1. No console da AWS, vá para o API Gateway e clique em **Create API**.
2. Escolha **HTTP API** (mais simples e econômico que o REST API para esse caso).
3. Dê um nome para sua API (por exemplo, `GithubWebhookReceiverAPI`).
4. No próximo passo, escolha **Create a route** e configure:
   - **Method**: POST (porque o GitHub Webhook vai enviar uma solicitação POST).
   - **Resource Path**: `/github-webhook`.
5. Agora, escolha o destino da rota:
   - **Integration type**: Escolha **Lambda function**.
   - **Lambda Function**: Selecione a função Lambda que vamos criar no próximo passo.
6. Finalize a criação da API e copie o **Invoke URL** gerado (será o URL usado como Payload no Webhook do GitHub).

## 3. Criar a Função AWS Lambda

Agora, você vai criar a função AWS Lambda que será acionada quando o webhook do GitHub fizer um push para o API Gateway. Esta Lambda será responsável por disparar o GitHub Actions no repo 2.

1. No console da AWS, vá para o Lambda e clique em **Create function**.
2. Escolha **Author from scratch**:
   - **Function name**: Nomeie a função, por exemplo, `TriggerGitHubActions`.
   - **Runtime**: Escolha Python 3.x (ou outra linguagem que preferir).
3. Depois de criar a função, vá para a aba **Configuration > Environment Variables** e crie uma variável chamada `GITHUB_TOKEN` com o valor do Personal Access Token (PAT) do GitHub. Esse token será usado para autenticar chamadas à API do GitHub.
   - Nota: Você pode gerar o token em GitHub > Settings > Developer Settings > Personal Access Tokens. Dê permissões para "repo" e "workflow".

4. No editor de código da Lambda, insira o seguinte código Python (adapte conforme necessário para sua linguagem preferida):

```python
import json
import requests
import os
import logging

# Configurar o logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        # Recebe o body do evento do webhook
        body = json.loads(event['body'])
        logger.info("Evento recebido: %s", body)
        
        # Verifica se o push foi feito na branch master (ou outra branch de interesse)
        if body.get('ref') == 'refs/heads/master':
            repo_owner = 'seu-usuario'  # Nome do usuário ou organização no GitHub
            repo_name = 'repo-2'        # Nome do repositório onde os testes estão
            workflow_id = 'workflow.yaml'  # Nome do arquivo GitHub Actions no repo 2
            
            # Headers para autenticação usando o Personal Access Token (PAT)
            headers = {
                'Authorization': f'token {os.environ["GITHUB_TOKEN"]}',
                'Accept': 'application/vnd.github.v3+json'
            }
            
            # URL da API GitHub para disparar o workflow
            url = f'https://api.github.com/repos/{repo_owner}/{repo_name}/actions/workflows/{workflow_id}/dispatches'
            data = {
                'ref': 'main'  # Branch onde você quer executar os testes no repo 2
            }
            
            # Dispara o workflow
            response = requests.post(url, headers=headers, json=data)
            logger.info("Resposta da API GitHub: %d %s", response.status_code, response.text)
            
            if response.status_code == 204:
                message = 'Workflow acionado com sucesso!'
                logger.info(message)
                return {
                    'statusCode': 200,
                    'body': json.dumps(message)
                }
            else:
                message = f'Erro ao acionar workflow: {response.text}'
                logger.error(message)
                return {
                    'statusCode': response.status_code,
                    'body': json.dumps(message)
                }
        else:
            message = 'Push detectado, mas fora da branch especificada.'
            logger.info(message)
            return {
                'statusCode': 200,
                'body': json.dumps(message)
            }
    
    except Exception as e:
        # Captura e registra qualquer exceção
        error_message = f'Erro durante a execução: {str(e)}'
        logger.error(error_message)
        return {
            'statusCode': 500,
            'body': json.dumps(error_message)
        }
```

## 4. Adicionar Layers para Dependências

Se a função Lambda precisar de bibliotecas adicionais (como `requests`), você pode adicionar um layer.

### Passos para Adicionar um Layer:

1. **Criar um Layer com Dependências**:
   - Crie um diretório para suas dependências e instale as bibliotecas necessárias:
     ```bash
     mkdir python
     pip install requests -t python/
     ```
   - Compacte o diretório `python` em um arquivo ZIP:
     ```bash
     zip -r layer.zip python
     ```
   - No console AWS Lambda, vá para **Layers** e crie um novo layer, fazendo upload do arquivo ZIP criado.

2. **Adicionar o Layer à Função Lambda**:
   - Na configuração da função Lambda, adicione o layer criado.

## 5. Configurar o Workflow no GitHub Actions (repo 2)

Agora você precisa configurar o GitHub Actions no repo 2 para ser acionado quando o `workflow_dispatch` for chamado (pela Lambda).

1. Crie ou edite o arquivo `.github/workflows/workflow.yaml` no repo 2 para incluir o gatilho `workflow_dispatch`. Isso permite que o workflow seja acionado manualmente ou via API.

```yaml
name: Run Tests on Push

on:
  workflow_dispatch:  # Aciona quando o workflow_dispatch for chamado
  
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - name: Check out code
      uses: actions/checkout@v2
    - name: Run tests
      run: |
        # Comandos de teste
        echo "Executando testes..."
        # Coloque aqui os comandos que você usa para rodar os testes no repo 2
```

## 6. Concluir a Configuração do Webhook

Agora, volte ao repo 1 no GitHub e vá para a configuração do Webhook:

1. Insira o **Invoke URL** da API Gateway como o **Payload URL** do webhook.
2. Teste fazendo um push no repo 1 e veja se o GitHub Actions no repo 2 é acionado.

## Monitoramento e Logs

1. **Logs da Lambda**:
   - Acesse o [Console AWS CloudWatch](https://console.aws.amazon.com/cloudwatch/).
   - Navegue até **Logs**.
   - Encontre o grupo de logs `/aws/lambda/<nome-da-funcao>`.
   - Clique nos streams de logs para visualizar as mensagens.

2. **Logs do API Gateway**:
   - O API Gateway também gerará logs úteis no CloudWatch para analisar qualquer erro nas chamadas do webhook.

3. **Resultados dos Testes**:
   - Os resultados do GitHub Actions podem ser monitorados diretamente na aba **Actions** no repo 2 no GitHub.

## Benefícios desse Processo

- **Automação Completa**: Uma vez configurado, você tem um fluxo automatizado que dispara testes sem intervenção manual.
- **Separação de Repositórios**: O uso de dois repositórios separados permite que você mantenha o código e os

 testes desacoplados.
- **Escalabilidade e Custo**: O uso de Lambda garante que você pague apenas pelo tempo de execução necessário, sem precisar manter servidores para a automação.

Esse processo permite que você acione automação de testes em um repositório com base em eventos de outro repositório, utilizando ferramentas da AWS e GitHub Actions para criar um pipeline ágil e eficiente.
