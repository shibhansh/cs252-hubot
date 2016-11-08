#!/bin/bash
echo "IITK User Id: "
read user
echo "Password: "
stty -echo
read  passd
stty echo
env HUBOT_SLACK_TOKEN=xoxb-98837274053-FGvXnxcjJP7BIBYpZx1wibA1 HUBOT_EMAIL_USER=$user HUBOT_EMAIL_PWD=$passd ./bin/hubot -a slack