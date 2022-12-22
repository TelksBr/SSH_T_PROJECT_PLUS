while true
do
badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 9000 --max-connections-for-client 8 --client-socket-sndbuf 10000
sleep 1
done
