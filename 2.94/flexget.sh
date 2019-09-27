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
