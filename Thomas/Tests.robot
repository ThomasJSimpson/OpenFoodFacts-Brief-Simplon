*** Settings ***
# Cette library est native
Library    String
# installer la bibliothèque avec la commande suivante : pip install robotframework-faker
Library    FakerLibrary    locale=fr_FR
# Appeler la library AppuimLibrary après les deux autres
Library    AppiumLibrary

Test Setup    Ouvrir App
# Test Teardown    Terminate Application    openfoodfacts.github.scrachx.openfood

*** Variables ***
# Configuration Appium
${URL_APPIUM}    http://127.0.0.1:4723


Creation de Compte + Déco + Reco

    [Documentation]    Génère des données uniques + inscription + connexion + ajout produit
    # Welcoming Check
    Wait Until Page Contains    Scannez un code-barres ou recherchez un produit    timeout=15s
    Wait Until Element Is Visible    accessibility_id=Chercher un produit    timeout=15s
    #Acces a l'onglet "Communauté"
    Click Element    accessibility_id=Communauté
    Wait Until Page Contains    Créer un compte    timeout=15s
    
    # Click sur "Créer un compte"
    Click Element    accessibility_id=Créer un compte 

    # Vérifie que le bouton "S'inscrire" s'affiche et le stock pour cliquer plus tard dessus
    ${el0}=    Set Variable    android=new UiSelector().description("S'inscrire")
    Wait Until Element Is Visible   ${el0}    timeout=15s

    # Génération des données dynamiques
    ${nom_complet}=      FakerLibrary.Name
    ${pseudo}=           Generer Pseudo Unique
    ${email}=            Generer Email Point Com
    ${mot_de_passe}=     Generate Random String    12    [LETTERS][NUMBERS]

    # Pouvoir lire les infos dans la console
    Log To Console    Nom: ${nom_complet}
    Log To Console    Pseudo: ${pseudo}
    Log To Console    Email: ${email}
    Log To Console    MDP: ${mot_de_passe}

    # Nom complet
    ${el1}=    Set Variable     android=new UiSelector().className("android.widget.EditText").instance(0)
    Click Element    ${el1}
    Input Text    ${el1}    ${nom_complet}

    # Email
    ${el2}=    Set Variable     android=new UiSelector().className("android.widget.EditText").instance(1)
    Click Element    ${el2}
    Input Text    ${el2}    ${email}

    # UserName
    ${el3}=    Set Variable     android=new UiSelector().className("android.widget.EditText").instance(2)
    Click Element    ${el3}
    Input Text    ${el3}    ${pseudo}

    # Password 1
    ${el4}=    Set Variable     android=new UiSelector().className("android.widget.EditText").instance(3)
    Click Element    ${el4}
    Input Text    ${el4}    ${mot_de_passe}

    # Password 2 (vérif.)
    ${el5}=    Set Variable     android=new UiSelector().className("android.widget.EditText").instance(4)
    Click Element    ${el5}
    Input Text    ${el5}    ${mot_de_passe}
    
    # Acceptation conditions d'utilisation en cliquant sur le switch 
    ${el6}=    Set Variable    android=new UiSelector().description("Je suis d'accord avec les ")
    Click Element    ${el6}
    
    # Vérif. switch activé
    ${checkStatus}=    Get Element Attribute    android=new UiSelector().className("android.widget.Switch").instance(0)    checked
    Should Be Equal As Strings    ${checkStatus}    true
    # Click sur "S'inscrire"
    Click Element    ${el0}
    
    # Vérif. message de validation + OK + affichage status connecté
    ${el7}=    Set Variable    accessibility_id=Toutes nos félicitations ! Votre compte vient d'être créé.
    Wait Until Element Is Visible    ${el7}    timeout=15s
    Click Element    accessibility_id=Ok

    # Vérif "connecté"
    ${el8}=    Set Variable    accessibility_id=${pseudo}
    Wait Until Element Is Visible    ${el8}    timeout=15s
    Wait Until Page Contains    Merci d'être l'un de nos membres !    timeout=15s

    # Déconnexion
    Click Element    accessibility_id=Gérez votre compte
    Click Element    accessibility_id=Se déconnecter
    Click Element    accessibility_id=Oui

    # Connexion
    Click Element    accessibility_id=Se connecter
    ${el9}=    Set Variable    android=new UiSelector().className("android.widget.EditText").instance(0)
    Click Element    ${el9}
    Input Text    ${el9}    ${email}
    ${el10}=    Set Variable    android=new UiSelector().className("android.widget.EditText").instance(1)
    Click Element    ${el10}
    Input Text    ${el10}    ${mot_de_passe}
    Click Element   xpath=//android.widget.Button[@content-desc="Se connecter"]
    Wait Until Element Is Visible    ${el8}    timeout=15s
    Wait Until Page Contains    Merci d'être l'un de nos membres !    timeout=15s
    
Ajout props à un aliment

    [Documentation]    En tant qu'utilisateur connecté, ajout d'une propriété à un produit

    ${el11}=    Set Variable     accessibility_id=Scanner
    Click Element    ${el11}
    Sleep    15s
    # Welcoming Check

    ${el12}=    Set Variable     accessibility_id=Chercher un produit
    Click Element    ${el12}
    Sleep    1s
    # 3033710061983
    ${el13}=    Set Variable     class=android.widget.EditText
    Click Element    ${el13}
    Input Text    ${el13}    8000500119358
    

    ${el14}=    Set Variable     accessibility_id=Rechercher
    Click Element    ${el14}
    
    Swipe By Percent    90    95    5    95    duration=1000
    Sleep    1s

    Swipe By Percent    90    95    5    95    duration=1000
    Sleep    1s

    ${el15}=    Set Variable     android=new UiSelector().className("android.widget.Button").instance(9)
    Click Element    ${el15}
    ${el16}=    Set Variable     accessibility_id=Ajouter une propriété
    Click Element    ${el16}
    ${props}=           Generer Pseudo Unique
    ${valueProps}=     Generate Random String    12    [LETTERS][NUMBERS]
    ${el17}=    Set Variable     android=new UiSelector().className("android.widget.EditText").instance(0)
    Click Element    ${el17}
    Input Text    ${el17}    ${props}
    ${el18}=    Set Variable     android=new UiSelector().className("android.widget.EditText").instance(1)
    Click Element    ${el18}
    Input Text    ${el18}    ${valueProps}
    ${el19}=    Set Variable     xpath=//android.widget.Button[@content-desc="Enregistrer"]
    Click Element    ${el19}
    ${el20}=    Set Variable     xpath=//android.widget.Button[@content-desc="Retour"]
    Click Element    ${el20}
    Sleep    1s
    Swipe By Percent    90    53    5    53    duration=1000
    Swipe By Percent    90    53    5    53    duration=1000
    Sleep    1s
    ${el21}=    Set Variable    xpath=//android.view.View[contains(@content-desc,"Folksonomie")]
    Click Element    ${el21}
    Sleep    1s
    # Test hors écran
    Scroll Down    android=new UiSelector().description("${props}")    retry_interval=0:00:01
    Expect Element    android=new UiSelector().description("${props}")    visible
    Expect Element    android=new UiSelector().description("${valueProps}")    visible

*** Keywords ***

Generer Pseudo Unique
    [Documentation]    Crée un pseudo
    ${random_suffix}=    Generate Random String    4    [LOWER][NUMBERS]
    ${pseudo}=           Set Variable    user${random_suffix}
    RETURN               ${pseudo}

Generer Email Point Com
    [Documentation]    Génère email
    ${prefixe}=          FakerLibrary.User Name
    ${random_num}=       Generate Random String    3    [NUMBERS]
    ${email}=            Set Variable    ${prefixe}${random_num}@testmail.com
    RETURN               ${email}

Check Welcoming Element
    [Documentation]    Vérifie l'écran relou
    Expect Element    accessibility_id=Bienvenue !    visible

Pass Welcoming
    [Documentation]    Passe l'écran relou
    ${el22}=    Set Variable     accessibility_id=Continuer
    Click Element    ${el22}
    Sleep    2s
    ${el23}=    Set Variable     android=new UiSelector().descriptionStartsWith("Veuillez sélectionner un pays")
    Click Element    ${el23}
    Sleep    2s
    
    ${el24}=    Set Variable     class=android.widget.EditText
    Click Element    ${el24}
    Sleep    2s
    
    ${el25}=    Set Variable     class=android.widget.EditText
    
    Input Text    ${el25}    France
    Sleep    2s

    ${el26}=    Set Variable     android=new UiSelector().description("OpenFoodFactsCountry.FRANCE")
    Click Element    ${el26}
    Sleep    2s
    
    ${el27}=    Set Variable     accessibility_id=Suivant
    Click Element    ${el27}
    Sleep    2s
    
    ${el28}=    Set Variable     accessibility_id=Suivant
    Click Element    ${el28}
    Sleep    2s
    
    ${el29}=    Set Variable     accessibility_id=Suivant
    Click Element    ${el29}
    Sleep    2s
    
    ${el30}=    Set Variable     accessibility_id=Suivant
    Click Element    ${el30}
    Sleep    2s

Welcoming Check
    [Documentation]    Procédure ecran relou
    ${passed}=    Run Keyword And Return Status   Check Welcoming Element
    IF    ${passed}    Pass Welcoming

Ouvrir App
    [Documentation]    Ouvrir l'application mobile.
    Open Application    ${URL_APPIUM}
    ...    platformName=Android
    ...    appium:automationName=UIAutomator2
    ...    appium:appPackage=openfoodfacts.github.scrachx.openfood
    ...    appium:appActivity=org.openfoodfacts.app.MainActivity
    ...    appium:noReset=${True}
    ...    appium:newCommandTimeout=${3600}
    ...    appium:connectHardwareKeyboard=${True}
