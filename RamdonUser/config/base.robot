*** Settings ***

Library     Collections
Library     RequestsLibrary
Library     JSONLibrary
Library     OperatingSystem
Library     String
Library     /home/runner/work/DesafioQAItauRogerioJordao/DesafioQAItauRogerioJordao/services/data/RandomUser.py
Resource    /home/runner/work/DesafioQAItauRogerioJordao/DesafioQAItauRogerioJordao/services/api-RandomUser/random-user-service.robot
#Library     ${EXECDIR}/services/data/RandomUser.py #Caminhos usados para rodar os testes localmente, fazendo referecia aos arquivos separados por pasta.
#Resource    ${EXECDIR}/services/api-RandomUser/random-user-service.robot #Caminhos usados para rodar os testes localmente, fazendo referecia aos arquivos separados por pasta.
