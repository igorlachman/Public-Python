#!/bin/bash
  
APP_ROOT=''
APP_NAME=''

IP_ADDR=`ifconfig | grep inet | grep broadcast | grep 255.255.255.0 | awk '{print$2}'`
BOT_ID=''
CHANNEL_ID=''

cd $APP_ROOT
rm -rf $APP_ROOT$APP_NAME
echo '[Cloning repo] ...'
echo '[Branch] dev_lachman'
`git clone --branch dev_lachman https://github.com/igorlachman/simple_flask_app.git`
echo '[Cloning repo] - [Done]'
echo '[----------------------------]'
echo '[Start building an image from Dokerfile] ...'
cd $APP_ROOT$APP_NAME
`/usr/bin/docker build -t simple_flask_app . >> update_log`
echo '[Build image with latest tag] - [Done]'
echo '[----------------------------]'
echo '[Runing container] ...'
`/usr/bin/docker stop simple_flask_app >> update_log`
`/usr/bin/docker rm simple_flask_app >> update_log`
`/usr/bin/docker run --name=simple_flask_app -td -p3000:3000 simple_flask_app >> update_log `
echo '[Runing container] - [Done]'
echo '[----------------------------]'
STAT=`docker inspect simple_flask_app|grep 'Status'|awk '{print $2}'`
CONTAINER_ID=`docker ps | grep simple_flask_app | awk '{print$1}'`
CONTAINER_PORT=`docker ps | grep simple_flask_app | awk '{print$13}'`
echo '[Container name] - [simple_flask_app]'
echo '[Container id] - ['$CONTAINER_ID']'
echo '[Container port] - ['$CONTAINER_PORT']'
echo '[Status] - ['$STAT']'
echo '[----------------------------]'
ST='||Container_ID|_'$CONTAINER_ID'_|Container_status|_'$STAT'_|Container_link|_http://'$IP_ADDR':3000/|_'
`curl --silent 'https://api.telegram.org/'$BOT_ID'/sendMessage?chat_id='$CHANNEL_ID'&text='$ST >> update_log`

echo '[Bot sended messages to Telegram channel]'
echo '[Log File] - [/home/ubuntu/Flask/simple_flask_app/update_log]'
echo '[----------------------------]'
echo 'All steps done'
