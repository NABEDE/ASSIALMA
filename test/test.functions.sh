#!/bin/bash
source ../components/functions.sh
source ../components/variables.sh


# ------------- Test de la fonction error_exit -----------------


error_exit  "Une erreur s'est produite"
if ! error_exit; then
    echo "Erreur dans la fonction"
    #return 1
else
    echo "La fonction a été bien exécutée"
    return 1
fi


# ----- Test de la fonction info_msg ----------------
info_msg "Test de la fonction info_msg"

if info_msg; then
    echo "La fonction a bien été exécuté sans erreur"
else
    echo "La fonction présente des erreurs, veillez vérifier dans votre code"
fi

success_msg "Test de la fonction success_msg"

if success_msg; then
    echo "La fonction a bien été exécuté sans erreur"
else
    echo "La fonction présente des erreurs, veillez vérifier dans votre code"
fi

warn_msg "Test de la fonction warning_msg"

user_interaction

show_help


