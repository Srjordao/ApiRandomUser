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
