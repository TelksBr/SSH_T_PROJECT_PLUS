#!/bin/bash
fun_ip () {
if [[ -e /etc/MEUIPADM ]]; then
IP="$(cat /etc/MEUIPADM)"
else
MEU_IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
MEU_IP2=$(wget -qO- ipv4.icanhazip.com)
[[ "$MEU_IP" != "$MEU_IP2" ]] && IP="$MEU_IP2" || IP="$MEU_IP"
echo "$MEU_IP2" > /etc/MEUIPADM
fi
}

fun_bar () {
comando="$1"
 _=$(
$comando > /dev/null 2>&1
) & > /dev/null
pid=$!
while [[ -d /proc/$pid ]]; do
echo -ne " \033[1;33m["
   for((i=0; i<10; i++)); do
   echo -ne "\033[1;31m##"
   sleep 0.2
   done
echo -ne "\033[1;33m]"
sleep 1s
echo
tput cuu1
tput dl1
done
echo -e " \033[1;33m[\033[1;31m####################\033[1;33m] - \033[1;32m100%\033[0m"
sleep 1s
}

webmin_update () {
# https://clouding.io/hc/es/articles/360010749399-C%C3%B3mo-Instalar-Webmin-en-Ubuntu-18-04
apt-get update -y > /dev/null 2>&1
apt-get upgrade -y > /dev/null 2>&1
apt-get install software-properties-common apt-transport-https wget -y
wget -q http://www.webmin.com/jcameron-key.asc -O- | apt-key add -
add-apt-repository "deb [arch=amd64] http://download.webmin.com/download/repository sarge contrib"
apt-get install webmin
ufw allow 10000/tcp
sleep 1s
service webmin restart > /dev/null 2>&1
}

web_min () {
 [[ -e /etc/webmin/miniserv.conf ]] && {
echo -e "\033[1;34m[\033[1;37m•\033[1;34m]\033[1;37m ➩ \033[1;33mREMOVER WEBMIN \033[0;32m"
echo -e "\033[1;34mDeseja Prosseguir? [S/N]: \033[0;32m"; read x
 [[ $x = @(n|N) ]] && msg -bar && return
 fun_bar "apt-get remove webmin -y"
echo -e "\033[1;34m[\033[1;37m•\033[1;34m]\033[1;37m ➩ \033[1;33mREMOVIDO COM SUCESSO \033[0;32m"
 [[ -e /etc/webmin/miniserv.conf ]] && rm /etc/webmin/miniserv.conf
 return 10
 }
echo -e "\033[1;34m[\033[1;37m•\033[1;34m]\033[1;37m ➩ \033[1;33mINSTALAR WEBMIN \033[0;32m"
echo -e "\033[1;34mDeseja Prosseguir? [S/N]: \033[0;32m"; read x
[[ $x = @(n|N) ]] && msg -bar && return
fun_bar "service ssh restart"
fun_ip
echo -ne "\033[1;34mConfirme seu ip \033[0;32m"; read -p ": " -e -i $IP ip
echo -ne "\033[1;34mEstamos prontos para configurar seu servidor Webmin \033[0;32m"
echo -ne "\033[1;34mDesea Seguir? [S/N]: \033[0;32m"; read x
[[ $x = @(n|N) ]] && msg -bar && return
# echo -e ""
# Actualiza Sistema
echo -ne " \033[1;31m[ ! ] apt-get update"
apt-get update -y > /dev/null 2>&1 && echo -e "\033[1;32m [OK]" || echo -e "\033[1;31m [FAIL]"
echo -ne " \033[1;31m[ ! ] apt-get upgrade"
apt-get upgrade -y > /dev/null 2>&1 && echo -e "\033[1;32m [OK]" || echo -e "\033[1;31m [FAIL]"
# Install webmin
echo -ne " \033[1;31m[ ! ] add-apt-repository"
sleep 3s > /dev/null 2>&1 && echo -e "\033[1;32m [OK]" || echo -e "\033[1;31m [FAIL]"
apt-get install software-properties-common apt-transport-https wget -y > /dev/null 2>&1
wget -q http://www.webmin.com/jcameron-key.asc -O- | apt-key add -  > /dev/null 2>&1
add-apt-repository "deb [arch=amd64] http://download.webmin.com/download/repository sarge contrib"  > /dev/null 2>&1
echo -ne " \033[1;31m[ ! ] apt-get install webmin"
apt-get install webmin -y > /dev/null 2>&1 && echo -e "\033[1;32m [OK]" || echo -e "\033[1;31m [FAIL]"
ufw allow 10000/tcp
sleep 1s
service webmin restart > /dev/null 2>&1
fun_ip
echo -e "\033[1;34mAcesso via web usando o link \033[0;32mhttps://$IP:10000"
echo -e ""
echo -ne "\n\033[1;31mENTER \033[1;33mpara retornar ao \033[1;32mMENU!\033[0m"; read
}
web_min
