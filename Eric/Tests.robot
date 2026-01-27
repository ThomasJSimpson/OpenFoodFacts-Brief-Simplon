*** Settings ***
Resource            resources/listes_keywords.resource

Suite Teardown      Fermer Application
Test Setup          Ouvrir App


*** Test Cases ***
Création liste courses
    Création liste courses
    Bouton retour

Ajout de quenelles dans la liste de courses
    Ajout de quenelles dans la liste de courses

Supprimer les quenelles de la liste de courses
    Supprimer les quenelles de la liste de courses
