# Configuração para Criar Issues com Base em Falhas de Testes no GitHub Actions

Este guia explica como configurar uma ação do GitHub Actions para criar uma issue automaticamente quando testes falham, utilizando a ação `actions/github-script`.

## Objetivo

O objetivo é criar uma issue no GitHub sempre que houver falhas nos testes, fornecendo detalhes sobre os erros encontrados no arquivo de resultados `output.xml`.

## Configuração do Workflow

Adicione o seguinte trecho ao seu arquivo de configuração do GitHub Actions (geralmente `.github/workflows/<seu-workflow>.yaml`):

```yaml
name: Test and Create Issue

on: [push]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.x'  # Altere para a versão do Python desejada

    - name: Install dependencies
      run: |
        pip install -r requirements.txt

    - name: Run tests
      run: |
        # Comandos para rodar seus testes
        pytest

    - name: Create Issue if Tests Fail
      if: always()  # Executa sempre, independentemente do sucesso ou falha
      uses: actions/github-script@v6
      with:
        script: |
          const fs = require('fs');
          const path = require('path');

          try {
            // Lendo o arquivo output.xml
            const xmlFilePath = path.join(process.env.GITHUB_WORKSPACE, 'results', 'output.xml');
            const xmlContent = fs.existsSync(xmlFilePath) ? fs.readFileSync(xmlFilePath, 'utf8') : null;

            // Verifica se o arquivo output.xml foi encontrado e tem conteúdo
            if (!xmlContent || xmlContent.trim() === '') {
              console.log('⚠️ Arquivo output.xml não encontrado ou está vazio. Não será criada uma issue.');
              return;
            }

            // Procurando por mensagens de falha no XML
            const failRegex = /<status status="FAIL".*?>\s*(.*?)\s*<\/status>/gi;
            let match;
            let failText = '';

            while ((match = failRegex.exec(xmlContent)) !== null) {
              failText += `💥 ${match[1].trim()}\n\n`;
            }

            // Se não houver falhas, não cria a issue
            if (!failText) {
              console.log('🎉 Todos os testes passaram. Não será criada uma issue.');
              return;
            }

            // Configuração dos detalhes da issue
            const issueTitle = `⚠️ Testes falharam em ${context.workflow} - ${new Date().toISOString()}`;

            // Limite de caracteres para o corpo da issue
            const characterLimit = 15000;

            // Criar corpo da issue com os detalhes dos erros
            const issueBody = `
              ## 🛑 Detalhes do Erro

              **⚠️ Logs contendo "FAIL":**
              \`\`\`
              ${failText.slice(0, characterLimit)}
              \`\`\`

              🚀 **Ação Recomendada:** Verifique os logs acima para identificar e corrigir os erros. Vamos melhorar esses testes! 💪
            `;

            // Criar a issue no repositório
            await github.rest.issues.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              title: issueTitle,
              body: issueBody,
              labels: ['bug', 'automated test failure'],
            });
          } catch (error) {
            console.log('❌ Erro ao processar o arquivo XML ou criar a issue:', error.message);
          }
```

## Explicação

- **if: always()**: Este passo será executado sempre, independentemente do sucesso ou falha dos testes. Isso garante que a issue será criada mesmo se os testes falharem.

- **actions/github-script@v6**: Utiliza a ação `github-script` para executar um script JavaScript que processa o arquivo `output.xml` e cria uma issue no repositório se houver falhas.

- **Script JavaScript**:
  - **Leitura do arquivo `output.xml`**: Lê o conteúdo do arquivo XML onde os resultados dos testes são armazenados.
  - **Procura por falhas**: Usa uma expressão regular para encontrar mensagens de falha no XML.
  - **Criação da Issue**: Se houver falhas, cria uma issue no repositório com os detalhes das falhas.

## Benefícios

- **Automação**: Automatiza o processo de criação de issues para falhas de testes, facilitando a identificação e correção de problemas.
- **Visibilidade**: Garante que as falhas nos testes sejam destacadas e tratadas rapidamente.
- **Eficiência**: Reduz a necessidade de monitoramento manual dos resultados dos testes, economizando tempo e esforço.

## Monitoramento e Validação

Após configurar a ação, monitore o repositório para verificar se a issue está sendo criada corretamente quando há falhas nos testes. Você pode visualizar as issues criadas na aba "Issues" do seu repositório no GitHub.
