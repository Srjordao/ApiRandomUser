*** Settings ***

Library     Collections
Library     RequestsLibrary
Library     JSONLibrary
Library     OperatingSystem
Library     String
Library     ../services/data/RandomUser.py
Resource    ../services/api-RandomUser/random-user-service.robot
