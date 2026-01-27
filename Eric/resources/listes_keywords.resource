*** Settings ***
Library     AppiumLibrary


*** Variables ***
${LISTES_LOCATOR}       accessibility_id=Listes
${MENU_LOCATOR}         accessibility_id=Afficher le menu
${VIDER_LOCATOR}        accessibility_id=Vider la liste
${CONFIRMER_LOCATOR}    accessibility_id=Oui
${SCANNER_LOCATOR}      accessibility_id=Scanner
${COMMUNAUTE}           accessibility_id=Communauté


*** Keywords ***
Ouvrir App
    [Documentation]    Ouvrir l'application mobile
    Open Application    http://127.0.0.1:4723
    ...    platformName=Android
    ...    appium:automationName=UIAutomator2
    ...    appium:appPackage=openfoodfacts.github.scrachx.openfood
    ...    appium:appActivity=org.openfoodfacts.app.MainActivity
    ...    appium:noReset=${True}
    ...    appium:dontStopAppOnReset=${True}
    ...    appium:newCommandTimeout=${3600}
    ...    appium:connectHardwareKeyboard=${True}
    ...    appium:settings[enforceXpath1]=${True}

Fermer Application
    Close Application

Bouton retour
    Press Keycode    4

Création liste courses
    # [Documentation] Création d'une liste de courses
    ${el11} =    Set Variable    accessibility_id=Listes
    Click Element    ${el11}
    ${el1} =    Set Variable    accessibility_id=Listes
    Click Element    ${el1}
    ${el2} =    Set Variable    accessibility_id=Historique des produits consultés, Changer la liste actuelle
    Click Element    ${el2}
    ${el13} =    Set Variable    accessibility_id=Créer une nouvelle liste
    Click Element    ${el13}
    ${el14} =    Set Variable    class=android.widget.EditText
    Click Element    ${el14}
    Input Text    ${el14}    Ma liste de courses
    Wait Until Element Is Visible    accessibility_id=Créer
    ${el15} =    Set Variable    accessibility_id=Créer
    Click Element    ${el15}

Ajout de quenelles dans la liste de courses
    Click Element    ${SCANNER_LOCATOR}
    Click Element    accessibility_id=Chercher un produit
    Wait Until Element Is Visible    class=android.widget.EditText
    Input Text    class=android.widget.EditText    quenelles
    Click Element    accessibility_id=Rechercher
    Wait Until Page Contains Element
    ...    xpath=//*[contains(@content-desc,'Quenelles')]
    ...    10s
    Click Element    xpath=//*[contains(@content-desc,'Quenelles')]
    Swipe    start_x=918    start_y=2254    end_x=216    end_y=2254
    Click Element    android=new UiSelector().className("android.widget.Button").instance(10)
    ${el1} =    Set Variable    accessibility_id=Ma liste de courses
    Click Element    ${el1}
    ${el2} =    Set Variable    accessibility_id=Fermer
    Click Element    ${el2}
    ${el3} =    Set Variable    accessibility_id=Retour
    Click Element    ${el3}
    ${el4} =    Set Variable    accessibility_id=Retour
    Click Element    ${el4}
    ${el5} =    Set Variable    accessibility_id=Fermer
    Click Element    ${el5}

Supprimer les quenelles de la liste de courses
    Click Element    ${LISTES_LOCATOR}
    Click Element    android=new UiSelector().className("android.widget.Button").instance(0)
    ${el16} =    Set Variable    accessibility_id=Afficher le menu
    Click Element    ${el16}
    ${el17} =    Set Variable    accessibility_id=Vider la liste
    Click Element    ${el17}
    ${el18} =    Set Variable    accessibility_id=Oui
    Click Element    ${el18}
    Bouton retour
    ${el19} =    Set Variable    accessibility_id=Scanner
    Wait Until Element Is Visible    ${el19}
    Click Element    ${el19}
