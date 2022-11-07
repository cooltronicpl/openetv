#!/bin/bash
iptables -I INPUT -p tcp -m tcp --dport 81 -j ACCEPT
iptables -I INPUT -p udp -m udp --dport 81 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -I INPUT -p udp -m udp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -I INPUT -p udp -m udp --dport 22 -j ACCEPT
pkill vlc
pkill cvlc
killall vlc
killall cvlc
rm /tmp/openetv.pid
pkill openetv.py
killall openetv.py
cd /root/openetv
i=1
while ! ping -c1 192.168.2.99 | grep -F "64 bytes from 192.168.2.99" > /dev/null;
do
    echo "TV server: waiting for ping addr for $i s"
    sleep 1
    echo $i > /tmp/openetv.cnt
    i=$((i+1)) 
done
echo "TV server is online"
#systemctl start sshd
python2 ./openetv.py start
