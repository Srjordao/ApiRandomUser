*** Settings ***
Library     RequestsLibrary
Library     FakerLibrary
Library     JSONLibrary
Library     Collections
Library     DateTime
Library     random.py

*** Variable ***
${URL}      https://randomuser.me/
${response}
${keys}
${expected_keys}

*** Keywords ***

Conectar API 
    Create Session  consultarAPI   ${URL}

Teste de Requisicao Basica  

    ${response}    Get On Session   consultarAPI    /api    
    Should Be Equal As Numbers    ${response.status_code}    200
    Log    ${response.status_code}
    ${json_data}    Set Variable    ${response.json()}
    Dictionary Should Contain Key     ${json_data}  results   

Teste de Estrutura de Resposta
    
    ${response}    Get On Session    consultarAPI    /api
    ${json_data}    Set Variable    ${response.json()}
    Log    ${json_data}
    Dictionary Should Contain Key    ${json_data}    results
    Should Not Be Empty    ${json_data}
    ${expected_keys}=    Create List    gender    name    location    email    login
    FOR    ${key}    IN    @{expected_keys}
    Dictionary Should Contain Key    ${json_data['results'][0]}    ${key}
    Log    ${json_data['results'][0]}
    Log    ${key}
    END
     ${expected_keysTwo}=    Create List    username    password
    FOR    ${keyTwo}    IN    @{expected_keysTwo}
    Dictionary Should Contain Key    ${json_data['results'][0]['login']}    ${keyTwo}
    Dictionary Should Contain Key    ${json_data['results'][0]['login']}    ${keyTwo}
    Log    ${keyTwo}
    END

Teste de Tipos de Dados
    ${response}    Get On Session    consultarAPI    /api
    ${json_data}    Set Variable    ${response.json()}
    Log    ${json_data}
    Should Be String    ${json_data['results'][0]['gender']}
    Should Match Regexp  ${json_data['results'][0]['email']}     ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$
    Should Match Regexp  ${json_data['results'][0]['dob']['date']}      \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z
    Should Match Regexp  ${json_data['results'][0]['registered']['date']}   \\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z 
    Should Match Regexp  ${json_data['results'][0]['picture']['large']}      ^https?://.*\.(?:png|jpe?g|gif|bmp)$
    Should Match Regexp  ${json_data['results'][0]['picture']['medium']}      ^https?://.*\.(?:png|jpe?g|gif|bmp)$
    Should Match Regexp  ${json_data['results'][0]['picture']['thumbnail']}     ^https?://.*\.(?:png|jpe?g|gif|bmp)$
    Log    ${json_data['results'][0]['picture']} 

Teste de Tipos de Dados - Postcode
    ${response}    Get On Session    consultarAPI    /api
    ${json_data}    Set Variable    ${response.json()}
    Log    ${json_data}
    Should Be Equal As Numbers      ${json_data['results'][0]['location']['postcode']}       ${json_data['results'][0]['location']['postcode']}
    Log  ${json_data['results'][0]['location']['postcode']}

Teste de Tipos de Conteudo
   ${response}    Get On Session    consultarAPI    /api
    ${json_data}    Set Variable    ${response.json()}

    ${name_title}    Set Variable    ${json_data["results"][0]["name"]["title"]}
    ${allowed_titles}=    Create List    Mr    Ms    Miss    Mrs    Madame    Monsieur
    List Should Contain Value    ${allowed_titles}    ${name_title}

    ${name_country}    Set Variable    ${json_data["results"][0]["nat"]}
    ${list_country}=    Create List    AD    AE    AF    AG    AI    AL    AM    AO    AQ    AR    AS    AT    AU    AW    AX    AZ    BA    BB    BD    BE    BF    BG    BH    BI    BJ    BL    BM    BN    BO    BQ    BR    BS    BT    BV    BW    BY    BZ    CA    CC    CD    CF    CG    CH    CI    CK    CL    CM    CN    CO    CR    CU    CV    CW    CX    CY    CZ    DE    DJ    DK    DM    DO    DZ    EC    EE    EG    EH    ER    ES    ET    FI    FJ    FK    FM    FO    FR    GA    GB    GD    GE    GF    GG    GH    GI    GL    GM    GN    GP    GQ    GR    GS    GT    GU    GW    GY    HK    HM    HN    HR    HT    HU    ID    IE    IL    IM    IN    IO    IQ    IR    IS    IT    JE    JM    JO    JP    KE    KG    KH    KI    KM    KN    KP    KR    KW    KY    KZ    LA    LB    LC    LI    LK    LR    LS    LT    LU    LV    LY    MA    MC    MD    ME    MF    MG    MH    MK    ML    MM    MN    MO    MP    MQ    MR    MS    MT    MU    MV    MW    MX    MY    MZ    NA    NC    NE    NF    NG    NI    NL    NO    NP    NR    NU    NZ    OM    PA    PE    PF    PG    PH    PK    PL    PM    PN    PR    PS    PT    PW    PY    QA    RE    RO    RS    RU    RW    SA    SB    SC    SD    SE    SG    SH    SI    SJ    SK    SL    SM    SN    SO    SR    SS    ST    SV    SX    SY    SZ    TC    TD    TF    TG    TH    TJ    TK    TL    TM    TN    TO    TR    TT    TV    TW    TZ    UA    UG    UM    US    UY    UZ    VA    VC    VE    VG    VI    VN    VU    WF    WS    XK    YE    YT    ZA    ZM    ZW
    List Should Contain Value    ${list_country}    ${name_country}

    Run Keyword If    ${json_data["results"][0]["location"]["coordinates"]["latitude"]} >= -90 and ${json_data["results"][0]["location"]["coordinates"]["latitude"]} <= 90    Should Be True    ${True}
    Run Keyword If    ${json_data["results"][0]["location"]["coordinates"]["longitude"]} >= -180 and ${json_data["results"][0]["location"]["coordinates"]["longitude"]} <= 180    Should Be True    ${True}


*** Settings ***
Library     Collections
Library     RequestsLibrary
Library     JSONLibrary
Library     OperatingSystem
Library     String
Library     ${EXECDIR}/services/data/RandomUser.py
Resource    ${EXECDIR}/services/api-RandomUser/random-user-service.robot
Resource    ${EXECDIR}/config/base.robot
Resource    ${EXECDIR}/services/api-RandomUser/random-user-service.robot
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
