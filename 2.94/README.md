# transmission
高性能比特流下载工具，BT种子高速上传分享，支持PT站下载

## 安装环境
当前支持CentOS6/7操作系统。

### 脚本命令 ###
1. 一键安装transmission+webGUI

```
wget https://github.zhiqiang.name/zylx0532/transmission/master/2.94/transmissionbt.sh -O transmissionbt.sh;sh transmissionbt.sh
```

### 配置文件 ###
1. transmission
```
service transmissiond stop
vi /home/transmission/.config/transmission/settings.json
```
rpc-username 帐号
rpc-password 密码
rpc-port 端口
rpc-authentication-required 是否开启使用账号密码加密访问

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
Transmission是2.94版本的，最新稳定版本。需要其它版本的朋友可以下载脚本修改。
此版本适用于CentOS6，包含32位的64位。
主程序编译安装在/usr/share/transmission/web/目录，有需要可自行美化web网页控制台。
