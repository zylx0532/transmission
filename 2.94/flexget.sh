#!/bin/bash
echo "========================================================================="
echo "Thanks for using Flexget for CentOS Auto-Install Script"
echo "========================================================================="
yum install -y gcc make zlib zlib-devel readline-devel sqlite sqlite-devel openssl-devel mysql-devel gd-devel openjpeg-devel

cd ~
wget https://npm.taobao.org/mirrors/python/2.7.14/Python-2.7.14.tar.xz --no-check-certificate
tar Jxvf Python-2.7.14.tar.xz
pushd Python-2.7.14
./configure --prefix=/usr/share/python && \
make && \
make install && \
ln -s /usr/share/python/bin/python2.7 /usr/local/bin/python
source ~/.bash_profile
popd

yum -y install epel-release
yum -y install python-pip
wget https://bootstrap.pypa.io/get-pip.py --no-check-certificate
/usr/local/bin/python get-pip.py
ln -s /usr/share/python/bin/pip /usr/local/bin/pip
pip install --upgrade pip
pip install --upgrade setuptools

pip install --upgrade pip
pip install --upgrade setuptools
pip install flexget
pip install transmissionrpc

mkdir -p /root/.flexget
cd .flexget
wget -c https://github.zhiqiang.name/zylx0532/transmission/master/2.94/config.yml --no-check-certificate -O config.yml
/usr/local/bin/flexget -c /root/.flexget/config.yml execute
echo "*/5 * * * * /usr/local/bin/flexget -c /root/.flexget/config.yml" >> /etc/crontab

wget https://github.zhiqiang.name/zylx0532/transmission/master/2.94/trans_cleanup.sh --no-check-certificate -O /root/trans_cleanup.sh
chmod 777 /root/trans_cleanup.sh
echo "*/1 * * * * /bin/bash /root/trans_cleanup.sh" >> /etc/crontab



service transmissiond stop 2&> /dev/null
mv -f /home/transmission/Downloads /home
mv -f /home/transmission/.config/transmission/resume /home
mv -f /home/transmission/.config/transmission/torrents /home
rm -rf /home/transmission
rm -rf /usr/share/transmission
mkdir -p /home/transmission
mkdir -p /home/transmission/.config/transmission
mv -f /home/Downloads /home/transmission
mv -f /home/resume /home/transmission/.config/transmission
mv -f /home/torrents /home/transmission/.config/transmission
cd /root
wget -c https://github.zhiqiang.name/zylx0532/transmission/master/2.94/intltool-0.40.6.tar.gz --no-check-certificate -O intltool-0.40.6.tar.gz
tar zxf intltool-0.40.6.tar.gz
cd intltool-0.40.6
./configure --prefix=/usr
make -s
make -s install
cd ..
wget -c https://github.zhiqiang.name/zylx0532/transmission/master/2.94/libevent-2.0.21-stable.tar.gz --no-check-certificate -O libevent-2.0.21-stable.tar.gz
tar zxf libevent-2.0.21-stable.tar.gz
cd libevent-2.0.21-stable
./configure
make -s
make -s install
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
ln -s /usr/local/lib/libevent-2.0.so.5 /usr/lib/libevent-2.0.so.5
ln -s /usr/local/lib/libevent-2.0.so.5.1.9 /usr/lib/libevent-2.0.so.5.1.9
ln -s /usr/lib/libevent-2.0.so.5 /usr/local/lib/libevent-2.0.so.5
ln -s /usr/lib/libevent-2.0.so.5.1.9 /usr/local/lib/libevent-2.0.so.5.1.9
echo install Transmisson
cd /root
wget -c https://github.zhiqiang.name/zylx0532/transmission/master/2.94/transmission-2.94.tar.xz --no-check-certificate -O transmission-2.94.tar.xz
tar Jxvf transmission-2.94.tar.xz
cd transmission-2.94
./configure --prefix=/usr
make -s
make -s install
useradd -m transmission
passwd -d transmission
wget https://github.zhiqiang.name/zylx0532/transmission/master/2.94/transmission.sh --no-check-certificate -O /etc/init.d/transmissiond
chmod 755 /etc/init.d/transmissiond
chkconfig --add transmissiond
chkconfig --level 2345 transmissiond on
mkdir -p /home/transmission/Downloads/
chmod g+w /home/transmission/Downloads/
wget -c https://github.zhiqiang.name/zylx0532/transmission/master/2.94/settings.json --no-check-certificate -O settings.json
mkdir -p /home/transmission/.config/transmission/
mv -f settings.json /home/transmission/.config/transmission/settings.json
chown -R transmission.transmission /home/transmission
wget -c https://github.zhiqiang.name/zylx0532/transmission/master/2.94/index.html -O index.html --no-check-certificate
mv -f index.html /usr/share/transmission/web/index.html
wget -O webgui.sh https://github.zhiqiang.name/zylx0532/transmission/master/2.94/webgui.sh --no-check-certificate && bash webgui.sh
service transmissiond start
/sbin/iptables -I INPUT -p tcp --dport 9091 -j ACCEPT
/sbin/iptables -I INPUT -p tcp --dport 65050 -j ACCEPT
/sbin/iptables -I INPUT -p udp --dport 65050 -j ACCEPT
service iptables save
service ip6tables stop 2&> /dev/null
chkconfig ip6tables off 2&> /dev/null
echo "========================================================================="
echo "Install end"
echo "========================================================================="
echo ""
echo "Login: http://ip:9091"
echo ""
echo "Default username: zhiqiang"
echo ""
echo "Default password: zhiqiang"
echo ""
echo "Download Folder: /home/transmission/Downloads/"
echo ""
echo "Please change your username(rpc-username) and password(rpc-password) in the file :"
echo "/home/transmission/.config/transmission/settings.json"
echo ""
echo "https://www.zhiqiang.name"
echo ""
echo "Thank you!"
echo "========================================================================="
