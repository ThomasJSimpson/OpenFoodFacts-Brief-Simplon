*** Settings ***
Library     AppiumLibrary
Test Setup    Ouvrir App

*** Keywords ***
Ouvrir App
    [Documentation]    Ouvrir l'application mobile pour préparer les tests suivants.
    Open Application    http://127.0.0.1:4723
    ...    platformName=Android
    ...    appium:automationName=UIAutomator2
    ...    appium:appPackage=com.wdiodemoapp
    ...    appium:appActivity=.MainActivity
    ...    appium:noReset=${True}
    ...    appium:dontStopAppOnReset=${True}
    ...    appium:ensureWebviewsHavePages=${True}
    ...    appium:nativeWebScreenshot=${True}
    ...    appium:newCommandTimeout=${3600}
    ...    appium:connectHardwareKeyboard=${True}

*** Test Cases ***

MyFirstTest
    [Documentation]    Test de la connexion "Login"
    Click Element    accessibility_id=Login
    Wait Until Page Contains    Login / Sign up    timeout=10s

    Input Text    accessibility_id=input-email    test@gmail.com
    Input Text    accessibility_id=input-password    bonjouwwwww

    Click Element    accessibility_id=button-LOGIN

    Wait Until Page Contains    You are logged in!    timeout=10s
    Page Should Contain Text    You are logged in!

    Click Element    id=android:id/button1

    Wait Until Page Does Not Contain    You are logged in!    timeout=5s
    Page Should Not Contain Text    You are logged in!
