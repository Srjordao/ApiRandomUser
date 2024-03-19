*** Settings ***
Resource    /home/runner/work/DesafioQA---Itau---Rogerio-Jordao/DesafioQA---Itau---Rogerio-Jordao/config/base.robot
Resource    /home/runner/work/DesafioQA---Itau---Rogerio-Jordao/DesafioQA---Itau---Rogerio-Jordao/services/api-RandomUser/random-user-service.robot
#Resource    ${EXECDIR}/config/base.robot
#Resource    ${EXECDIR}/services/api-RandomUser/random-user-service.robot
Library     Collections
Library     FakerLibrary
Library     String


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
