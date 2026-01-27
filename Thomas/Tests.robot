*** Settings ***
Library             AppiumLibrary

Suite Setup         Ouvrir Application OpenFoodFacts
Suite Teardown      Fermer Application


*** Variables ***
${REMOTE_URL}       http://127.0.0.1:4723
${PLATFORM}         Android
${AUTOMATION}       UIAutomator2
${APP_PACKAGE}      openfoodfacts.github.scrachx.openfood
${APP_ACTIVITY}     org.openfoodfacts.app.MainActivity


*** Test Cases ***
E2E - Recherche d’un produit
    Rechercher Un Produit    nutella


*** Keywords ***
Ouvrir Application OpenFoodFacts
    Open Application    ${REMOTE_URL}
    ...    platformName=${PLATFORM}
    ...    appium:automationName=${AUTOMATION}
    ...    appium:appPackage=${APP_PACKAGE}
    ...    appium:appActivity=${APP_ACTIVITY}
    ...    appium:noReset=${True}
    ...    appium:connectHardwareKeyboard=${True}

Fermer Application
    Close Application

Rechercher Un Produit
    [Arguments]    ${produit}
    Click Element    accessibility_id=Chercher un produit
    Input Text    class=android.widget.EditText    ${produit}
    Click Element    accessibility_id=Rechercher
