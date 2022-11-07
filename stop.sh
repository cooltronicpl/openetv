#!/bin/sh
pkill vlc
pkill cvlc
killall vlc
killall cvlc
cd /root/openetv
python2 ./openetv.py stop
