#!/usr/bin/python
# -*- coding: UTF-8 -*-

import os
import commands
import time

# transmission用户名
username="zhiqiang"
 
# transmission密码
password="zhiqiang"

# transmission下载目录
download_dir="/home/transmission/Downloads"

# 最大磁盘占用率 (%)
disk_used_max=85


# 自动关机 (Disable=0, Enable=1)
enable_auto_shutdown=0

# 日志文件设置
log_path="/var/log/trans_cleanup.log"



#检查磁盘占用率
def disk_check():
    if int(commands.getstatusoutput("df -h %s | grep -v Mounted | awk '{print $5}' | cut -d '%%' -f 1"%(download_dir))[1]) >disk_used_max:
        return 1
    return 0

if disk_check() :
    for i in commands.getstatusoutput("transmission-remote --auth %s:%s -l | grep 100%% | grep Done | awk '{print $1}' | grep -v ID"%(username,password))[1].split():
        if i != 0:
            commands.getstatusoutput("echo -n %s [Done] >> %s"%(time.strftime("%y-%m-%d %H:%M:%S", time.localtime()),log_path))
        commands.getstatusoutput("transmission-remote --auth %s:%s -t %s --remove-and-delete >> %s 2>&1"%(username,password,i.strip("*"),log_path))
        time.sleep(10)
        if disk_check():
            continue
        break

if disk_check():
    for i in commands.getstatusoutput("transmission-remote --auth %s:%s -l | grep Stopped | grep Status | awk '{print $1}' | grep -v ID"%(username,password))[1].split():
        if i != 0:
            commands.getstatusoutput("echo -n %s [Stopped] >> %s"%(time.strftime("%y-%m-%d %H:%M:%S", time.localtime()),log_path))
        commands.getstatusoutput("transmission-remote --auth %s:%s -t %s --remove-and-delete >> %s 2>&1"%(username,password,i.strip("*"),log_path))
        time.sleep(10)
        if disk_check():
            continue
        break

if disk_check():
    for i in commands.getstatusoutput("transmission-remote --auth %s:%s -l | grep -v Sum | awk '{print $1}' | grep -v ID"%(username,password))[1].split():
        if i != 0:
            commands.getstatusoutput("echo -n %s [Up or Down] >> %s"%(time.strftime("%y-%m-%d %H:%M:%S", time.localtime()),log_path))
        commands.getstatusoutput("transmission-remote --auth %s:%s -t %s --remove-and-delete >> %s 2>&1"%(username,password,i.strip("*"),log_path))
        time.sleep(10)
        if disk_check():
            continue
        break

if disk_check():
    commands.getstatusoutput("rm -rf %s/*"%(log_path))