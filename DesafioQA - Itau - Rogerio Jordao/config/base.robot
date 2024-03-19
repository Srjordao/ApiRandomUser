*** Settings ***

Library     Collections
Library     RequestsLibrary
Library     JSONLibrary
Library     OperatingSystem
Library     String
Library     ${EXECDIR}/services/data/RandomUser.py
Resource    ${EXECDIR}/services/api-RandomUser/random-user-service.robot
Variables    ${EXECDIR}    DesafioQA - Itau - Rogerio Jordao

