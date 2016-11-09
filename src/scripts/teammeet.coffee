express = require "express"
nodemailer    = require "nodemailer"
smtpTransport = require('nodemailer-smtp-transport')
app = express()

smtpTransport = nodemailer.createTransport(smtpTransport(
  host: 'mmtp.iitk.ac.in',
  secureConnection: false,
  port: 25,
  auth:
    user: process.env.HUBOT_EMAIL_USER,
    pass: process.env.HUBOT_EMAIL_PWD))

module.exports = (robot) ->
  robot.respond /teammeet@ (.*)/i, (msg) ->
    time = msg.match[1]
    obj = {
      from: "HUBOT <pratikab@iitk.ac.in>",
      to: ["bhangalepratik8@gmail.com","pratikab@cse.iitk.ac.in"],
      subject: "Team Meeting",
      text: "Team meet on #{time}"
    }
    smtpTransport.sendMail obj, (error, response) ->
      if error 
        msg.send "There was an error: " + error
      else
        msg.send "Ok. I sent the email."