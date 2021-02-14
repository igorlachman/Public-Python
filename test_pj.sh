#!/bin/bash

cd '/home/ubuntu/Flask/'
rm -rf '/home/ubuntu/Flask/simple_flask_app/'
echo '[Cloning repo] ...'
echo '[Branch] dev_lachman'
`git clone --branch dev_lachman https://github.com/igorlachman/simple_flask_app.git`
echo '[Cloning repo] - [Done]'
echo '[----------------------------]'
echo '[Start building an image from Dokerfile] ...'
cd '/home/ubuntu/Flask/simple_flask_app'
`sudo /usr/bin/docker build -t simple_flask_app . >> update_log`
echo '[Build image with lates tag] - [Done]'
echo '[----------------------------]'
echo '[Runing container] ...'
`sudo /usr/bin/docker stop simple_flask_app >> update_log`
`sudo /usr/bin/docker rm simple_flask_app >> update_log`
`sudo /usr/bin/docker run --name=simple_flask_app -td -p3000:3000 simple_flask_app >> update_log `
echo '[Runing container] - [Done]'
echo '[----------------------------]'
STAT=`sudo /usr/bin/docker inspect simple_flask_app|grep 'Status'|awk '{print $2}'`
echo '[Container name] - [simple_flask_app]'
echo '[Status] - ['$STAT']'
echo '[----------------------------]'
UPD_BRANCH='Branch|_|dev_lachman|_|update'
BUILD_STATUS='Build|_|simple_flask_app|_|status|_|complete'
CONT_STATUS='Container|_|simple_flask_app|_|status|_|'$STAT
LINK='Container|_|simple_flask_app|_|link|_|http://3.17.78.88:3000/'

`curl 'https://api.telegram.org/<bot_id>/sendMessage?chat_id=<channel_id>&text='$UPD_BRANCH >> update_log`
`curl 'https://api.telegram.org/<bot_id>/sendMessage?chat_id=<channel_id>&text='$BUILD_STATUS >> update_log`
`curl 'https://api.telegram.org/<bot_id>/sendMessage?chat_id=<channel_id>&text='$CONT_STATUS >> update_log`
`curl 'https://api.telegram.org/<bot_id>/sendMessage?chat_id=<channel_id>&text='$LINK >> update_log`

echo '[Bot sended messages to Telegram channel]'
echo '[Log File] - [/home/ubuntu/Flask/simple_flask_app/update_log]'
echo '[----------------------------]'
