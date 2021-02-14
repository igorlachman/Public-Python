#!/bin/bash

echo 'Testing project'
cd '/home/lachman/flask_webhook/'
rm -rf '/home/lachman/flask_webhook/simple_flask_app/'
`git clone --branch dev_lachman https://github.com/igorlachman/simple_flask_app.git`
echo 'Done. Repo cloned from dev_lachman. Start build...'
cd '/home/lachman/flask_webhook/simple_flask_app'
`/usr/bin/docker build -t simple_flask_app . >> update_log`
echo 'Done. Docker image builded. You can check /home/lachman/flask_webhook/simple_flask_app/update_log'
echo 'Runing container...'
`/usr/bin/docker stop simple_flask_app`
`/usr/bin/docker rm simple_flask_app`
`/usr/bin/docker run --name=simple_flask_app -t -d -p 3000:3000 simple_flask_app`
echo 'Done.'
STAT=`/usr/bin/docker inspect simple_flask_app | grep Status | awk '{print $2}'`
echo 'simple_flask_app status - [$STAT]`
