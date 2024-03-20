# Projeto Teste - Automação de Testes para a API

Este é um projeto de automação de testes para validar a API Random User Generator (https://randomuser.me/api/), que fornece dados fictícios de usuários aleatórios. O objetivo é garantir que a API funcione corretamente de acordo com o contrato estabelecido abaixo.

## Configurações

- Python 3.10 ou versão mais recente.
- Instale o Robot Framework e as dependências necessárias utilizando o seguinte comando:

    ```
    pip install -r requirements.txt
    pip install robotframework
    ```

## Estrutura de Pastas

- **Data**: Contém os corpos das chamadas da API e dados de massa.
- **Services**: Módulos para realização das requisições à API.
- **Tests**: Suites de testes.
- **Results**: Relatórios com os resultados dos testes.

## Casos de Teste

1. **Teste de Requisição Básica**: Verifica se a API responde corretamente.
2. **Teste de Estrutura de Resposta**: Garante que a estrutura da resposta da API esteja conforme o esperado.
3. **Teste de Tipos de Dados**: Verifica se os tipos de dados retornados estão corretos.
4. **Teste de Conteúdo**: Garante que o conteúdo retornado pela API seja válido.
5. **Teste de Desempenho**: Avalia o desempenho da API ao realizar múltiplas requisições.
6. **Teste de Confiabilidade**: Verifica a estabilidade da API ao executar os casos de teste repetidamente.

## Descrição dos Casos de Teste

### 1. Teste de Requisição Básica

- Envia uma solicitação GET para a URL da API.
- Verifica se a resposta possui o status code 200 (OK).
- Verifica se a resposta contém um objeto JSON válido conforme o contrato fornecido.

### 2. Teste de Estrutura de Resposta

- Verifica se a resposta contém a chave "results".
- Verifica se "results" é uma lista não vazia.
- Verifica se os objetos essenciais estão presentes dentro da resposta: "gender", "name", "location", "email", "login", "username" e "password".

### 3. Teste de Tipos de Dados

- Verifica se o valor de "gender" é uma string.
- Verifica se "email" é uma string válida de email.
- Verifica se "dob" e "registered" contêm datas no formato ISO 8601.
- Verifica se "postcode" contém apenas números.
- Verifica se os valores dentro de "picture" são URLs válidas.

### 4. Teste de Conteúdo

- Verifica se os valores de "name.title" estão dentro de um conjunto predefinido.
- Verifica se os valores de "nat" estão dentro de um conjunto predefinido de códigos de país ISO 3166-1 alpha-2.
- Verifica se as coordenadas em "coordinates" de latitude e longitude estão dentro de intervalos válidos.

### 5. Teste de Desempenho

- Executa uma série de solicitações para a API e mede o tempo de resposta médio.

### 6. Teste de Confiabilidade

- Executa os casos de teste várias vezes para verificar a estabilidade da API.