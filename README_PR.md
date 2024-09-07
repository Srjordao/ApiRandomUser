# Configuração para Comentar em Pull Requests se os Testes Falharem

Este guia explica como configurar uma ação do GitHub Actions para comentar automaticamente em Pull Requests (PRs) quando um workflow de CI/CD falha, utilizando a ação `actions/github-script`.

## Objetivo

O objetivo é adicionar um comentário em Pull Requests quando o workflow de CI/CD falha, informando aos desenvolvedores que há problemas que precisam ser corrigidos antes da fusão.

## Configuração do Workflow

Adicione o seguinte trecho ao seu arquivo de configuração do GitHub Actions (geralmente `.github/workflows/<seu-workflow>.yaml`):

```yaml
name: Comment on PR if Tests Fail

on:
  workflow_run:
    workflows: ["CI/CD Pipeline"]  # Nome do workflow principal que deve ser monitorado
    types:
      - completed

jobs:
  comment:
    if: ${{ github.event.workflow_run.conclusion == 'failure' }}
    runs-on: ubuntu-latest

    steps:
      - name: Comment on PR
        uses: actions/github-script@v6
        with:
          script: |
            const { owner, repo } = context.repo;
            const pull_number = context.payload.workflow_run.pull_requests[0].number;
            const body = 'The build has failed. Please check the logs and fix the issues before merging.';
            await github.rest.issues.createComment({
              owner,
              repo,
              issue_number: pull_number,
              body,
            });
```

## Explicação

- **on: workflow_run**: Este evento é acionado quando o workflow especificado (neste caso, `"CI/CD Pipeline"`) é concluído. O workflow que você deseja monitorar deve ser nomeado corretamente no campo `workflows`.

- **if: ${{ github.event.workflow_run.conclusion == 'failure' }}**: Este condicional garante que o job de comentário só seja executado se o resultado do workflow monitorado for `failure`.

- **actions/github-script@v6**: Utiliza a ação `github-script` para executar um script JavaScript que adiciona um comentário ao Pull Request associado.

- **Script JavaScript**:
  - **Extração dos detalhes do repositório e Pull Request**: Obtém o nome do repositório e o número do Pull Request do evento `workflow_run`.
  - **Criação do comentário**: Adiciona um comentário ao Pull Request, informando sobre a falha e recomendando que os desenvolvedores verifiquem os logs e corrijam os problemas.

## Benefícios

- **Automação**: Automatiza o processo de notificação sobre falhas de build, garantindo que os desenvolvedores sejam informados imediatamente.
- **Visibilidade**: Ajuda a manter a visibilidade das falhas diretamente no contexto do Pull Request, facilitando a resolução de problemas.
- **Eficiência**: Reduz a necessidade de monitoramento manual e comunicação manual sobre falhas de build.

## Monitoramento e Validação

Após configurar a ação, monitore os Pull Requests para verificar se o comentário está sendo adicionado corretamente quando o workflow de CI/CD falha. Você pode visualizar os comentários diretamente na aba "Pull Requests" do seu repositório no GitHub.
