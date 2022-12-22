#!/bin/bash
[[ $(screen -list| grep -c 'bot_teste') == '0' ]] && {
    clear
    echo -e "\E[44;1;37m     ATIVACÃO BOT SSH TESTE     \E[0m"
    echo ""
    echo -ne "\n\033[1;32mINFORME O TOKEN\033[1;37m: "; read token
    cd $HOME/BOT
    screen -dmS bot_teste ./botssh $token > /dev/null 2>&1
    clear && echo "BOT TESTE ATIVADO ✔️"
} || {
    screen -r -S "bot_teste" -X quit
    clear && echo "BOT DESATIVADO"
}