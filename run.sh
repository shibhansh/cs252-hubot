#!/bin/bash
echo "IITK User Id: "
read user
echo "Password: "
stty -echo
read  passd
stty echo
env HUBOT_SLACK_TOKEN=xoxb-98837274053-FGvXnxcjJP7BIBYpZx1wibA1 HUBOT_EMAIL_ID=bhangalepratik8@gmail.com HUBOT_EMAIL_USER=$user HUBOT_EMAIL_PWD=$passd GMAIL_USER=bhangalepratik8@gmail.com GMAIL_PASSWORD=$passd GMAIL_LABEL=inbox GMAIL_FETCH_INTERVAL=1 ./bin/hubot -a slack