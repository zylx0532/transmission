#!/bin/bash
yum -y install wget unzip
wget -c https://github.zhiqiang.name/zylx0532/transmission/master/2.94/index.html -O index.html --no-check-certificate
mv -f index.html /usr/share/transmission/web/index.original.html
rm -rf /usr/share/transmission/web/index.html /usr/share/transmission/web/index.mobile.html /usr/share/transmission/web/tr-web-control
wget -c https://github.zhiqiang.name/zylx0532/transmission/master/2.94/webgui.zip -O webgui.zip --no-check-certificate
unzip -o webgui.zip
cd webgui
mv -f * /usr/share/transmission/web
