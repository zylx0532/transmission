# transmission
高性能比特流下载工具，BT种子高速上传分享，支持PT站下载

## 安装环境
当前支持CentOS6/7操作系统。

### 脚本命令 ###
1. 一键安装transmission+webGUI

```
wget https://github.com/zylx0532/transmission/master/2.94/transmissionbt.sh -O transmissionbt.sh;sh transmissionbt.sh
```

2. 一键安装FlexGet

```
wget https://github.com/zylx0532/transmission/master/2.94/flexget.sh -O flexget.sh;sh flexget.sh
```

### 配置文件 ###
1. transmission
配置文件示例：
```
service transmissiond stop
vi /home/transmission/.config/transmission/settings.json
```
rpc-username 帐号
rpc-password 密码
rpc-port 端口
rpc-authentication-required 是否开启使用账号密码加密访问

2. FlexGet
配置文件示例：
```
tasks:
  mt:
    rss: https://tp.m-team.cc/torrentrss.php?https=1&rows=10&cat410=1&cat429=1&cat424=1&cat430=1&icat=1&isize=1&iuplder=1&linktype=dl&passkey=*****
    accept_all: yes
    content_size:
      min: 1
      max: 8192
    download: /home/transmission/torrent
    transmission:
      host: 127.0.0.1
      port: 9091
      username: zhiqiang
      password: zhiqiang
```


### 卸载 ###
1. 卸载transmissionbt

```
service transmissiond stop
killall -9 transmission-da
rm -rf /home/transmission
rm -rf /usr/share/transmission
rm -rf /etc/init.d/transmissiond
```

## 说明
1、因为Transmission下载时，没有预分配磁盘空间，因此硬盘是一点一点占用的，只要达到了设置的阈值（比如80%），这个脚本就会清理已经完成的种子，如果空间还不够，就会清理正在下载的种子。因为脚本是每分钟执行的，所以没有硬盘塞满的风险。
2、硬盘总空间太小，就会经常需要删除旧的种子，这样一个种子的分享率可能就不高，长久下来，PT网站的总分享率也就不高了，可以通过调节接收种子的最大体积来影响（FlexGet配置文件中的8192表示最大接受8G的种子，超过就会被过滤，不会添加到Transmission中）。
Transmission是2.94版本的，最新稳定版本。需要其它版本的朋友可以下载脚本修改。
此版本适用于CentOS，包含32位的64位。
主程序编译安装在/usr/share/transmission/web/目录，有需要可自行美化web网页控制台。
