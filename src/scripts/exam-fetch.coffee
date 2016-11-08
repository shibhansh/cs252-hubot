express = require "express"
nodemailer    = require "nodemailer"
smtpTransport = require('nodemailer-smtp-transport')
app = express()
htmlToText = require('html-to-text')

url = "http://172.26.142.68/examscheduler2/personal_schedule.php?rollno="

smtpTransport = nodemailer.createTransport(smtpTransport(
  host: 'mmtp.iitk.ac.in',
  secureConnection: false,
  port: 25,
  auth:
    user: process.env.HUBOT_EMAIL_USER,
    pass: process.env.HUBOT_EMAIL_PWD))

module.exports = (robot) ->
	robot.respond /exam (.*)/i, (msg) ->
		roll = msg.match[1]
		fetch = url+roll
		msg.http(fetch) .get() (err, res, body) ->
			tex = htmlToText.fromString("#{body}", tables: ['.contenttable_lmenu'], wordwrap: 50)
			mail_id = roll+"@iitk.ac.in" 
			obj = {
			    from: "HUBOT <pratikab@iitk.ac.in>",
			    to: mail_id,
			    subject: "Exam Schedule for #{roll}",
			    text: "#{tex}"
		    }
		    smtpTransport.sendMail obj, (error, response) ->
          		if error 
            		msg.send "There was an error: " + error
          		else
            		msg.send "Ok. I sent the email."
			msg.send tex