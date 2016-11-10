#!/bin/bash
echo "IITK User Id: "
read user
echo "Password: "
stty -echo
read  passd
stty echo
env HUBOT_SLACK_TOKEN=xoxb-98837274053-FGvXnxcjJP7BIBYpZx1wibA1 HUBOT_EMAIL_ID=pratikab@iitk.ac.in HUBOT_EMAIL_USER=$user HUBOT_EMAIL_PWD=$passd EMAIL_LABEL=inbox EMAIL_FETCH_INTERVAL=1 ./bin/hubot -a slack