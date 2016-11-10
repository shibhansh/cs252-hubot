#CS-252 Hubot

##Introduction
This can be used as a personal/team bot for simple tasks (described below).

##Requirements
- Node.js and npm installed
- Redis Server
- Hubot
- Various npm libraries mentioned in package.json

##Functionalities
- Get Exam schedules
- Fetch mails
- Remind through mails
- Auto-add reminder from emails
- Finance management using Google Sheets
- Sticky Notes
- Team-meet scheduling
- Cleverbot
- Search news headlines

##How to use?
1. Get Exam Schedule
    exams <rollno>

2. Fetch mails
    - Fetches emails and displays them every one minute `email fetch start`
    - To stop fetching mail `email fetch stop`

3. Reminders
    - `remind me tomorrow to document this better`
    - `remind us in 15 minutes to end this meeting`
    - `remind at 5 PM to go home`
    - `(list|show|all) remind[ers]`
    - `remind[ers] (list|show|all)`
    - `[delete|remove|stop] remind[er] [NUMBER]`
    - `remind[er] (delete|remove|stop) [NUMBER]`
    - `remind in every 30 minutes to take a walk`
    - `remind[er] repeat [NUMBER]`
    - `repeat remind[er] [NUMBER]`

4. Finance management
    Add finance statement to google sheet `finance <amount> <description>`

5. Sticky Notes
    - Add sticky note `add note <description>`
    - Delete stick note `delete note <description>`
    - Show notes `show notes`

6. Team meet scheduling
    - Add teammate `add teammate email <emailid>`
    - List out teammates `show teammates`
    - Schedule meeting `meeting@ <time>`

7. Cleverbot
    Chat with cleverbot `@<msg>`

8. Google-news Headlines
    Search news on some key word `search news about <key>`

##Credits
- npm repository for node.js reminder constructor and apis
- https://github.com/vishals79/hubot-todo for slack-hubot integration

##Contributors
- Pratik Bhangale (14173)
- Rohit Mukku (14402)
- Shibhansh Dohare (14644)
