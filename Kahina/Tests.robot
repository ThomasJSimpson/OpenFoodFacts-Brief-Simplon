*** Settings ***
Documentation       Parcours Santé - Allergies et alerte produit (utilisateur déjà connecté)

Library             String
Library             AppiumLibrary

Suite Setup         Ouvrir App


*** Variables ***
${REMOTE_URL}           http://127.0.0.1:4723
${TIMEOUT}              20s
${PSEUDO}               kahina123
${PRODUIT_RECHERCHE}    HERTA Pâte à Pizza Fine et Rectangulaire 390g
${PREF_ALIM}            android=new UiSelector().descriptionContains("Préférences alimentaires")
${BTN_RETOUR}           accessibility_id=Retour
${SCORE_COMPAT}         android=new UiSelector().descriptionContains("Votre score de compatibilité")


*** Test Cases ***
CT-ALL-01 - Rien sélectionné
    [Documentation]    Aucun allergène sélectionné.
    Executer Parcours Allergies    NONE    NONE    NOME    RIEN

CT-ALL-02 - Gluten Obligatoire -> 0%
    [Documentation]    Allergène Gluten obligatoire → produit incompatible (0%).
    Executer Parcours Allergies    Sans Gluten    Obligatoire    0%    Gluten
# Sans Gluten = préférence utilisateur
# Obligatoire = niveau choisi
# GLUTEN = ce qu’on vérifie sur la fiche (“Contient : Gluten”)
# 0% = résultat attendu

CT-ALL-03 - Lait Important -> 10%
    [Documentation]    Vérifier qu’un allergène Lait en mode Important impacte le score sans bloquer totalement.
    Executer Parcours Allergies    Sans Lait    Important    10%    Lait

CT-ALL-04 - Arachide Important -> 38%
    [Documentation]    Vérifier qu’un allergène Arachide en mode Important impacte le score produit.
    Executer Parcours Allergies    Sans Arachides    Important    100%    Arachide


*** Keywords ***
# 1- OUVERTURE APP
Ouvrir App
    [Documentation]    Ouvrir l'app via Appium (1 fois pour la suite)
    Open Application
    ...    ${REMOTE_URL}
    ...    platformName=Android
    ...    appium:automationName=UIAutomator2
    ...    appium:appPackage=openfoodfacts.github.scrachx.openfood
    ...    appium:noReset=${True}
    ...    appium:dontStopAppOnReset=${True}
    ...    appium:ensureWebviewsHavePages=${True}
    ...    appium:nativeWebScreenshot=${True}
    ...    appium:newCommandTimeout=${3600}
    ...    appium:connectHardwareKeyboard=${True}
# 2- déja connecté

Verifier Deja Connecte
    [Documentation]    Vérifie que l’utilisateur est déjà connecté (pseudo visible)
    Wait Until Page Contains Element    xpath=//android.view.View[@content-desc="${PSEUDO}"]    ${TIMEOUT}
# 3- SCENARIO

Executer Parcours Allergies
    [Documentation]    Configure 0/1 allergène, ouvre la fiche produit, puis vérifie la fiche en 1 seule fois
    [Arguments]    ${ALLERGENES}    ${NIVEAU}    ${POURCENTAGE}    ${ALLERGENE_VERIFIE}

    IF    '${ALLERGENES}' != 'NONE'
        Selectionner Allergene Et Niveau    ${ALLERGENES}    ${NIVEAU}
    END

    Scanner Et Rechercher    ${PRODUIT_RECHERCHE}
    Verifier Fiche Selon Cas    ${ALLERGENE_VERIFIE}    ${POURCENTAGE}
# 4- CHOISIR Allergènes + niveau d'allergènes

Selectionner Allergene Et Niveau
    [Documentation]    Préférences alimentaires > Allergènes > choisir le niveau
    [Arguments]    ${ALLERGENES}    ${NIVEAU}

    # 1) Ouvrir Préférences alimentaires
    Wait Until Page Contains Element    ${PREF_ALIM}    ${TIMEOUT}
    Click Element    ${PREF_ALIM}

    # 2) Scroll jusqu’à l’allergène
    ${ALLERGENE_LOC}=    Set Variable
    ...    android=new UiScrollable(new UiSelector().scrollable(true)).scrollIntoView(new UiSelector().descriptionContains("${ALLERGENES}"))
    Wait Until Page Contains Element    ${ALLERGENE_LOC}    ${TIMEOUT}

    # 3) Cliquer le niveau par défaut
    # Sélectionner le PREMIER élément “Pas important”
    ${NIVEAU_ACTUEL}=    Set Variable
    ...    android=new UiSelector().description("Pas important").instance(0)
    Wait Until Page Contains Element    accessibility_id= ${ALLERGENES}    ${TIMEOUT}
    Click Element    ${NIVEAU_ACTUEL}

    # 4) Choisir le niveau demandé
    ${NIVEAU_CHOISI}=    Set Variable    accessibility_id=${NIVEAU}
    Wait Until Page Contains Element    ${NIVEAU_CHOISI}    ${TIMEOUT}
    Click Element    ${NIVEAU_CHOISI}

# 5- Scanner Et Rechercher

Scanner Et Rechercher
    [Documentation]    Scanner et rechercher un produit
    [Arguments]    ${PRODUIT_RECHERCHE}

    Wait Until Page Contains Element    accessibility_id=Scanner    ${TIMEOUT}
    Click Element    accessibility_id=Scanner

    Wait Until Page Contains Element    accessibility_id=Chercher un produit    ${TIMEOUT}
    Click Element    accessibility_id=Chercher un produit

    Wait Until Page Contains Element    class=android.widget.EditText    ${TIMEOUT}
    Click Element    class=android.widget.EditText
    Clear Text    class=android.widget.EditText
    Input Text    class=android.widget.EditText    ${PRODUIT_RECHERCHE}

    Wait Until Page Contains Element    accessibility_id=Rechercher    ${TIMEOUT}
    Click Element    accessibility_id=Rechercher

    Wait Until Page Contains Element
    ...    android=new UiSelector().descriptionContains("${PRODUIT_RECHERCHE}")
    ...    ${TIMEOUT}
    Click Element    android=new UiSelector().descriptionContains("${PRODUIT_RECHERCHE}")

Verifier Fiche Selon Cas
    [Documentation]    Vérifie la fiche produit selon le cas
    [Arguments]    ${ALLERGENE_VERIFIE}    ${POURCENTAGE}

    ${ALLERGENE_VERIFIE_UP}=    Convert To Upper Case    ${ALLERGENE_VERIFIE}
    IF    '${ALLERGENE_VERIFIE_UP}' == 'GLUTEN'
        Verifier Fiche Complete    ${POURCENTAGE}    Contient    Gluten
    ELSE IF    '${ALLERGENE_VERIFIE_UP}' == 'LAIT'
        Verifier Fiche Complete    ${POURCENTAGE}    Peut contenir    Lait
    ELSE IF    '${ALLERGENE_VERIFIE_UP}' == 'ARACHIDE'
        Verifier Fiche Complete    ${POURCENTAGE}    Ne contient pas    Arachides
    ELSE IF    '${ALLERGENE_VERIFIE_UP}' == 'RIEN'
        Verifier Absence Badge Compatibilite Sur Fiche
    ELSE
        Fail    CAS inconnu: '${ALLERGENE_VERIFIE_UP}'
    END
# sinon tu vérifies que le badge n’existe pas

Verifier Fiche Complete
    [Documentation]    Vérifie le badge % et la ligne allergène
    [Arguments]    ${POURCENTAGE}    ${STATUT}    ${ALLERGENES}
    # Badge compatibilité
    Wait Until Page Contains Element
    ...    xpath=//android.widget.Button[contains(@content-desc,"Votre score de compatibilité") and contains(@content-desc,"${POURCENTAGE}")]
    ...    ${TIMEOUT}

    # Ligne allergène
    Wait Until Page Contains Element
    ...    android=new UiSelector().descriptionContains("${STATUT} : ${ALLERGENES}")
    ...    ${TIMEOUT}

Verifier Absence Badge Compatibilite Sur Fiche
    [Documentation]    Vérifie l’absence du badge compatibilité
    # ...    xpath=//android.widget.Button[contains(@content-desc,"Votre score de compatibilité")]
    # Page Should Not Contain Element    accessibility_id=Votre score de compatibilité
    # IMPORTANT: on s'assure d'être sur la fiche produit
    Wait Until Page Contains Element    ${BTN_RETOUR}    ${TIMEOUT}
    Page Should Not Contain Element    ${SCORE_COMPAT}
