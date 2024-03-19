def Criar_Usuario(userName,firstName,lastName,pet,email,password,celular):
    return {
        "body": {
            "username": userName,
            "firstName": firstName,
            "lastName": lastName,
            "pet": pet,
            "email": email,
            "password": password,
            "phone": celular,
            "userStatus": 0
        }
    }

def Consultar_Usuario():
    return {
        "body": {
            "username": "" ,
            "firstName": "" ,
            "lastName": "" ,
            "pet": "" ,
            "email": "" ,
            "password": "",
            "phone": "",
            "userStatus": 0
        }
    }

def Alterar_Usuario(userName,firstName,lastName,pet,email,password,celular):
    return {
        "id": 1,
        "body": {
            "username": userName,
            "firstName": firstName,
            "lastName": lastName,
            "pet": pet,
            "email": email,
            "password": password,
            "phone": celular,
            "userStatus": 0
        },
        "id": 2,
        "body": {
            "username": userName,
            "firstName": firstName,
            "lastName": lastName,
            "pet": pet,
            "email": email,
            "password": password,
            "phone": celular,
            "userStatus": 0
        },
        "id": 3,
        "body": {
            "username": userName,
            "firstName": firstName,
            "lastName": lastName,
            "pet": pet,
            "email": email,
            "password": password,
            "phone": celular,
            "userStatus": 0
        }
    }

def Deletar_Usuario():
    return {
        "id": "1",
        "id": "2",
        "id": "3"
    }

def Banho(tipoBanho,pet,valor,desconto,status):
    return {
        "servico": 1,
            "Banho": tipoBanho,
            "Pet": pet,
            "Valor": valor,
            "Desconto": desconto,
            "Status": status
    }

def Tosa(tipoTosa,pet,valor,desconto,status):
    return {
            "servico": 2,
            "Tosa": tipoTosa,
            "Pet": pet,
            "Valor": valor,
            "Desconto": desconto,
            "Status": status
        }

def Combo(tipoBanhoTosa,pet,valor,desconto,status):
    return {
            "servico": 3,
            "Banho e Tosa": tipoBanhoTosa,
            "Pet": pet,
            "Valor": valor,
            "Desconto": desconto ,
            "Status": status
        }
    
def Deletar_Servicos():
    return {
        "id": "1",
        "id": "2",
        "id": "3",
    }