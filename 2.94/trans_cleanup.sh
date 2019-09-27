#! /bin/bash
#====================================================================
# trans_cleanup.sh
#
# Copyright (c) 2011, WangYan <webmaster@wangyan.org>
# All rights reserved.
# Distributed under the GNU General Public License, version 3.0.
#
# Monitor disk space, If the Over, delete some files.
#
# See: http://wangyan.org/blog/trans_cleanup.html
#
# V0.2, since 2012-10-29
#====================================================================
 
# The transmission remote login username
USERNAME="zhiqiang"
 
# The transmission remote login password
PASSWORD="zhiqiang"
 
# The transmission download dir
DLDIR="/home/transmission/Downloads"
 
# The maximum allowed disk (%)
DISK_USED_MAX="80"
 
# Enable auto shutdown support (Disable=0, Enable=1)
ENABLE_AUTO_SHUTDOWN="0"
 
# Log path settings
LOG_PATH="/var/log/trans_cleanup.log"
 
# Date time format setting
DATA_TIME=$(date +"%y-%m-%d %H:%M:%S")
 
#====================================================================
 
dist_check()
{
    DISK_USED=`df -h $DLDIR | grep -v Mounted | awk '{print $5}' | cut -d '%' -f 1`
    DISK_OVER=`awk 'BEGIN{print('$DISK_USED'>'$DISK_USED_MAX')}'`
}
 
dist_check
 
if [ "$DISK_OVER" = "1" ];then
        for i in `transmission-remote --auth $USERNAME:$PASSWORD -l | grep 100% | grep Done | awk '{print $1}' | grep -v ID`
        do
                [ "$i" -gt "0" ] && echo -n "$DATA_TIME [Done] " >> $LOG_PATH
                transmission-remote --auth $USERNAME:$PASSWORD -t $i --remove-and-delete >> $LOG_PATH 2>&1
                [ "$i" -gt "0" ] && sleep 10 && dist_check
                [ "$DISK_OVER" = "0" ] && break
        done
fi
 
if [ "$DISK_OVER" = "1" ];then
        for ii in `transmission-remote --auth $USERNAME:$PASSWORD -l | grep Stopped | awk '{print $1}' | grep -v ID`
        do
                [ "$ii" -gt "0" ] && echo -n "$DATA_TIME [Stopped] " >> $LOG_PATH
                transmission-remote --auth $USERNAME:$PASSWORD -t $ii --remove-and-delete >> $LOG_PATH 2>&1
                [ "$ii" -gt "0" ] && sleep 10 && dist_check
                [ "$DISK_OVER" = "0" ] && break
        done
fi
 
if [ "$DISK_OVER" = "1" ];then
        for iii in `transmission-remote --auth $USERNAME:$PASSWORD -l | grep -v Sum | awk '{print $1}' | grep -v ID`
        do
                [ "$iii" -gt "0" ] && echo -n "$DATA_TIME [Up or Down] " >> $LOG_PATH
                transmission-remote --auth $USERNAME:$PASSWORD -t $iii --remove-and-delete >> $LOG_PATH 2>&1
                [ "$iii" -gt "0" ] && sleep 10 && dist_check
                [ "$DISK_OVER" = "0" ] && break
        done
fi
 
if [ "$DISK_OVER" = "1" ];then
        rm -rf $DLDIR/*
fi
 
if [ "$ENABLE_AUTO_SHUTDOWN" = "1" ];then
        SHUTDOWN=1
        for STATUS in `transmission-remote --auth $USERNAME:$PASSWORD -l | awk '{print $9}'`
        do
                if [[ "$STATUS" = "Up" || "$STATUS" = "Uploading" ]];then
                        SHUTDOWN=0
                fi
        done
        TASK_TOTAL=`transmission-remote --auth $USERNAME:$PASSWORD -l | grep -Ev '(ID|Sum)' | wc -l`
        if [ "$TASK_TOTAL" -gt "0" ] && [ "$SHUTDOWN" -eq "1" ];then
                echo -n "$DATA_TIME " >> $LOG_PATH
                shutdown now >> $LOG_PATH 2>&1
        fi
fi