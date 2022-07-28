#!/bin/bash

DIR=/opt/
SERVICE=myservice.service
SCRIPT=myscript.sh

# check root permission
if [ $(id -u) != 0 ]; then
    echo "start script with root permission!"
    exit 1
fi

# create target diretory
if [ ! -e $DIR ]; then
    mkdir -p $DIR
fi

# install service files
cp $SCRIPT $DIR/
cp $SERVICE /usr/lib/systemd/system/$SERVICE

if [ -e /etc/systemd/system/$SERVICE ]; then
    rm /etc/systemd/system/$SERVICE
fi

ln -s /usr/lib/systemd/system/$SERVICE /etc/systemd/system/$SERVICE

if [ -e /etc/systemd/system/default.target.wants/$SERVICE ]; then
    rm /etc/systemd/system/default.target.wants/$SERVICE
fi

ln -s /usr/lib/systemd/system/$SERVICE /etc/systemd/system/default.target.wants/$SERVICE

# init and start
systemctl enable --now $SERVICE

