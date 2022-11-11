# OpenETV port by CoolTRONIC.pl sp. z o.o.

## 2022.10.1A - 2022-11-07
- code refactoring
- fixing of crashing or not starting app (checking multiple things in CentOS and Ubuntu)
- update things, like webserver stuck on select channel
- some dirty fixing stuck VLC (require root, and VLC fix)
- run as service with crony or crond (cron on @reboot) bash script with waiting for activity of Enigma STB 
- add best quality of stream
- change default port to 80 (http), and streaming port to 81
- some examples of HEVC encoding for new servers (in 2022 year)
- stopping script to release STB and stop all services (especially VLC transcode which runs in background)
 
## 201601703 - 2016-04-17 
- split everything up in multiple files/libs
- moved the configuration options to a config.ini file
- ssl cert error fix
- replaced vlc sigterm for sigkill when stopping the transcoding process
- some other fixes

## 2016.01 - 2016-01-10
- added transcoding options to the webgui

## 2015.02 - 2015-02-01
- added the vlc_hard_shutdown option
- added tracking of the vlc pid to kill vlc when stopping openetv and when the vlc_hard_shutdown option is used

## 2015.01 - 2015-01-30
- added authentication and ssl support

## 2014.09 - 2014-09-16
- added correct webserver headers, splitted the base64 image data into chucks, added the medium quality stream option

## 2014.06.07 - 2014-06-07
- splitted the base64 data into chunks according to RFC 2045 semantics

## 2014.06.04 - 2014-06-04
- initial app funcionality
