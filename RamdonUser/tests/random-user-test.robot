*** Settings ***
Library     Collections
Library     RequestsLibrary
Library     JSONLibrary
Library     OperatingSystem
Library     String
Library     Collections
Library     FakerLibrary
Library     String

Resource  /home/runner/work/RamdonUser/Services/api-RandomUser/random-user-service.robot
Resource  /home/runner/work/RamdonUser/config/base.robot

*** Variables ***
${URL}      https://randomuser.me/
${response}
${keys}
${expected_keys}

*** Test Cases ***

Conectar
    Conectar API 

Validar retorno 200 e JSON Válido
    [Documentation]    Testa se a API responde corretamente e retorna um objeto JSON válido.
    [Tags]  testeRequisicaoBasica

    Teste de Requisicao Basica

Validar estrutura de resposta
    [Documentation]    Testa a estrutura da resposta da API.
    [Tags]  testeEstruturaResposta

    Teste de Estrutura de Resposta

Validar tipos de dados 
    [Documentation]     Testa se os tipos de dados na resposta da API estão corretos.
    [Tags]  testeTiposDados

    Teste de Tipos de Dados
    Teste de Tipos de Dados - Postcode

Validar conteudo
    [Documentation]     Testa o conteúdo específico dos campos retornados pela API.
    [Tags]  testeConteudo

    Teste de Tipos de Conteudo
