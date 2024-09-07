import json
import requests
import os

def lambda_handler(event, context):
    # Recebe o body do evento do webhook
    body = json.loads(event['body'])
    
    # Verifica se o push foi feito na branch master (ou outra branch de interesse)
    if body.get('ref') == 'refs/heads/master':
        repo_owner = 'Nome do usuario do github'  # Nome do usuário ou organização no GitHub
        repo_name = 'Nome do repo'        # Nome do repositório onde os testes estão
        workflow_id = 'Nome do arquivo yaml'  # Nome do arquivo GitHub Actions no repo 2
        
        # Headers para autenticação usando o Personal Access Token (PAT)
        headers = {
            'Authorization': f'token {os.environ["GITHUB_TOKEN"]}',
            'Accept': 'application/vnd.github.v3+json'
        }
        
        # URL da API GitHub para disparar o workflow
        url = f'https://api.github.com/repos/{repo_owner}/{repo_name}/actions/workflows/{workflow_id}/dispatches'
        data = {
            'ref': 'master'  # Branch onde você quer executar os testes no repo 2
        }
        
        # Dispara o workflow
        response = requests.post(url, headers=headers, json=data)
        
        if response.status_code == 204:
            return {
                'statusCode': 200,
                'body': json.dumps('Workflow acionado com sucesso!')
            }
        else:
            return {
                'statusCode': response.status_code,
                'body': json.dumps(f'Erro ao acionar workflow: {response.text}')
            }
    else:
        return {
            'statusCode': 200,
            'body': json.dumps('Push detectado, mas fora da branch especificada.')
        }
