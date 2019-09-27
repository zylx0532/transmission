#!/bin/bash
yum -y install wget unzip
wget -c https://raw.githubusercontent.com/zylx0532/transmission/master/2.94/index.html --no-check-certificate -O index.html
mv -f index.html /usr/share/transmission/web/index.original.html
rm -rf /usr/share/transmission/web/index.html /usr/share/transmission/web/index.mobile.html /usr/share/transmission/web/tr-web-control
wget -c https://raw.githubusercontent.com/zylx0532/transmission/master/2.94/webgui.zip --no-check-certificate -O webgui.zip
unzip -o webgui.zip
cd webgui
mv -f * /usr/share/transmission/web
