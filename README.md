# OpenETV version 2022 for Proxmox LXC

OpenETV (Open Enigma TV Stream Server) is a media transcoding server for Enigma2 (Dreambox, VU+, Cyfra+ nBox HDTV, and other clone) devices.
With this application you can encode/compress the Enigma2 media channels of your Dreambox or clone
on the fly (transcoding) and make them available through http on you local network or the internet.

OpenETV has a build-in webserver for managing your streams. You can select your bouquets, channels and
start/stop the streams.

OpenETV talks to the WebIF (Web Interface) of your Enigma2 device to select your bouquets and channels.
For the time being it uses VLC to transcode the media and export a http stream.

Theoretically this application should run cross-platform because it's written in Python. It only requires
a proper Python/VLC installation. Linux (CentOS 6, Fedora 23 and Ubuntu 14.04) and Mac OS X run this application
successfully. Windows isn't tested yet, but should also work with a simular Python/VLC setup.


## TO BE SOON

Generate m3u playlist with compressed streams to your client.

## GETTING STARTED

First install the required dependencies:
- Python 2.6, 2.7 (LXC Ubuntu, CentOS7) or higher
- Python libxml2 library
- VLC 2.0.10 or higher
- Tested on proxmox on VM with CentOS 7 and fixed CT from pveam with CentOS7 default
- Preffered system is Ubuntu 20.04 LXC
- Debian 10
- Tested on nBox 5800 with Enigma2 and Graterlia

### Linux Centos 7

Note: the Linux install section is based and tested on CentOS 7 (and Fedora 23 in 2016 version). But if you want to run
it on other distro's the steps below are similar except for the package installation part.

To install the VLC packages on CentOS 7 or Fedora you need to add the rpmfusion, more info:
https://rpmfusion.org/Configuration

Install the VLC rpms:
```
sudo yum install -y vlc
```

Install the required Python libs:

```
sudo yum install -y libxml2-python
```

Fixing CentOS7 default LXC container (no console shell after boot, container not accesible after first initialization in Proxmox):

https://forum.proxmox.com/threads/pve-7-wont-start-centos-7-container.97834/post-425419

When you installing on CT LXC Proxmox pulseaudio is neeeded for better stablity of stream.
```
yum install pulseaudio
```
Also you can use NUX Repo.

### Linux Debian 10, Ubuntu (preffered is Ubuntu 20.04 LXC for Proxmox)

On Debian add non-free repos:
https://www.xmodulo.com/install-nonfree-packages-debian.html

```
apt-get install -y vlc
apt-get install -y python-libxml2
apt-get install -y pulseaudio
```

### Run VLC as root in LXC

sed -i 's/geteuid/getppid/' /usr/bin/vlc

### Mac OS X

Download and install VLC.
The easiest way to get the modules work is to download and install the Mac OS X ports.

And then install the required ports:

```
sudo port install python27 py27-libxml2
```

Edit openetv.py with your favorite editor and change the interpeter in openetv.py line 1 to:

```
!/opt/local/bin/python2.7
```

## Stop OpenETV when decoder is busy by VLC

```
/root/openetv/stop.sh
```

## Configure OpenETV

Edit config.ini with your favorite editor and configure the following options:

OpenETV directory, logfile and pidfile:
Set the openetv_dir variable to the directory path where OpenETV is located (for example: /opt/openetv).
Set the openetv_logfile and openetv_pidfile variables to a directory path where the openetv process can write to.

Enigma host:
Make sure the Enigma WebIf is enabled on your Dreambox or clone. If so, configure the ip address and the tcp port
of your device in the following options, for example:\

```
enigma2_host     = 192.168.0.10
enigma2_port     = 80
```

If you use https, and for example on port 443, set the enigma2_use_ssl variable to "yes": 

```
enigma2_port     = 443
enigma2_use_ssl  = yes
```

If you enabled authentication, set the enigma2_username and enigma2_password variables, for example:

```
enigma2_username = username
enigma2_password = password

```
VLC executable path:

Set the correct vlc executable path (default is Linux) by comment/uncommenting the vlc_exe variable.

## Start OpenETV
$ ./openetv.py start

Note: it's not recommended to start openetv as root. Instead create a service account and run openetv with
reduced privileges.

Launch your browser and go to: "http://<openetv-host>".

Select your bouquet and channel.

Select one of the transcoding options:
  1) Poor quality (this one I used on my old Intel Atom 330 fileserver and stream it over a 3G network to my Smartphone)
  2) Medium quality (I also used this one on my Intel ATOM C2750 with 4 threads enabled instead of 8)
  3) Good quality (this one I use on my Intel ATOM C2750 and stream it over a 3G network to my Smartphone)
  4) Best quality
Note: Transcoding is a heavy CPU intensive process so you need a PC with enough power to suit your needs.

Click on the "start stream" button. Then launch VLC on your client device
and connect it to "http://<openetv-host>:81".

If something went wrong you can check the openetv.log file for errors. If it doesn't have enough information
you can set the debug flag in openetv.py to 1 and restart it. Then repeat the browser steps and recheck the
logfile for more details.

Quality is modded to HEVC, to get maximum compression.

## ENABLE AUTOSTART IN CRON
Alternative start of Open Enigma TV Server is:

```
/root/openetv/start_service.sh
```

To add to cron on reebot:

```
crontab -e
```

Add this line to cron:

```
@reboot /root/openetv/start_service.sh
```

Save file and now openetv will run automatically on every reboot.
This script is pinging Enigma DVB tuner, you must change your internal network IP of Enigma2 STB (should be static, but you can use hostame).

## NOTES

On both distros you can install ffmpeg.

If you want to secure your OpenETV webserver for the big bad internet you can, for example, put it behind a
Apache HTTPD Server with a reverse proxy pass configuration and secure it with Apache authentication).
Or, another method, setup a VPN and use it over the VPN.
When you have active stream, in this example when \/tmp\/vlc.pid exist, try to stop in browser, when it is not posibble
you can stop script by executing:

```
/root/openetv/stop.sh
```

When you are away should SSH be used on VPN tunnel to your home network.

## INSTALL SSH SERVER 

When you are away you can add on CentOS, Fedora:

```
yum install openssh-server
```

on Debian, Ubuntu:

```
apt-get install openssh-server
```

On Ubuntu enable root login to machine:
https://www.liquidweb.com/kb/enable-root-login-via-ssh/

## LICENSE

Copyright (c) 2014 by Joey Loman, <joey@binbash.org>

Copyright (c) 2022 by CoolTRONIC.pl sp. z o.o. by Paweł Potacki, <github@cooltronic.pl>

https://cooltronic.pl/ https://potacki.com/

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation; either version v2 or v3 of the License.

See files COPYING.GPL2 and COPYING.GPL3 for License information.
