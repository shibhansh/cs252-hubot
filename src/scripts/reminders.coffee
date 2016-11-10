# Commands:
#   hubot remind me tomorrow to document this better
#   hubot remind us in 15 minutes to end this meeting
#   hubot remind at 5 PM to go home
#   hubot (list|show|all) remind[ers]
#   hubot remind[ers] (list|show|all)
#   hubot [delete|remove|stop] remind[er] [NUMBER]
#   hubot remind[er] (delete|remove|stop) [NUMBER]
#   hubot remind in every 30 minutes to take a walk
#   hubot remind[er] repeat [NUMBER]
#   hubot repeat remind[er] [NUMBER]
cleverbot = require('cleverbot-node')
express = require "express"
nodemailer    = require "nodemailer"
smtpTransport = require('nodemailer-smtp-transport')
app = express()
chrono = require 'chrono-node'
uuid = require 'node-uuid'
moment = require 'moment'
inbox        = require 'inbox'
{MailParser} = require 'mailparser'
htmlToText = require('html-to-text')
_ = require 'lodash'

url = "http://172.26.142.68/examscheduler2/personal_schedule.php?rollno="
smtpTransport = nodemailer.createTransport(smtpTransport(
  host: 'mmtp.iitk.ac.in',
  secureConnection: false,
  port: 25,
  auth:
    user: process.env.HUBOT_EMAIL_USER,
    pass: process.env.HUBOT_EMAIL_PWD))


envelope_key = (e) ->
  e.room || e.user.id

time_until = (date) ->
  date.getTime() - new Date().getTime()

chrono_parse = (text, ref) ->
  results = chrono.parse text, ref
  if results.length == 0
    return
  result = results[0]
  date = result.start.date()
  if time_until(date) <= 0 && result.tags.ENTimeExpressionParser
    ref = chrono.parse('tomorrow')[0].start.date()
    return chrono_parse text, ref
  result

class Reminders
  constructor: (@robot) ->
    @pending = {}
    @robot.brain.data.reminder_at ?= {}
    @robot.brain.on 'loaded', =>
        reminder_at = @robot.brain.data.reminder_at
        for own id, o of reminder_at
          reminder = new ReminderAt o.envelope, new Date(o.date), o.action
          if reminder.diff() > 0
            @queue(reminder, id)
          else
            @remove(id)

  queue: (reminder, id) ->
    if ! id?
      id = uuid.v4() while ! id? or @robot.brain.data.reminder_at[id]

    after = reminder.diff()
    @robot.logger.debug("add id: #{id} after: #{after}")

    setTimeout =>
      @fire(reminder, id)
    , after

    k = reminder.key()
    (@pending[k] ?= []).push reminder
    (@pending[k]).sort (r1, r2) -> r1.diff() - r2.diff()
    @robot.brain.data.reminder_at[id] = reminder

  fire: (reminder, id) ->
    unless reminder.is_deleted
      @robot.reply reminder.envelope, "***Reminder*** You asked me to remind you #{reminder.action}"
      obj = {
        from: "HUBOT <pratikab@iitk.ac.in>",
        to: process.env.HUBOT_EMAIL_ID,
        subject: "Reminder",
        text: "#{reminder.action}"
      }
      smtpTransport.sendMail obj, (error, response) ->
        if error 
          msg.send "There was an error: " + error
        else
          msg.send "Ok. I sent the email."
      @pending[reminder.key()].shift()
      @remove(id)
      setTimeout =>
        new_reminder = reminder.respawn @robot.logger
        if new_reminder
          @queue new_reminder, id
      , 1000

  remove: (id) ->
    @robot.logger.debug("remove id:#{id}")
    delete @robot.brain.data.reminder_at[id]

  list: (msg) ->
    k = envelope_key msg.envelope
    @robot.logger.debug("listing reminders for #{k}")
    p = @pending[k] || []
    if p.length == 0
      "No reminders"
    else
      lines = ("#{i+1}. #{r.listing()}" for r, i in p)
      lines.join('\n')

  idx_help: (text) ->
    "#{text}. Use the 'list reminders' command to see a list of existing reminders"

  delete: (msg, idx) ->
    k = envelope_key msg.envelope
    @robot.logger.debug("deleting reminder #{idx} for #{k}")
    p = @pending[k]
    unless p
      return @idx_help "No reminders."
    i = parseInt(idx) - 1
    unless i < p.length
      return @idx_help "No such reminder to remove"
    reminder = p.splice(i, 1)[0]
    reminder.is_deleted = true
    return "Removed reminder ##{i + 1}"

  repeat: (msg, idx) ->
    k = envelope_key msg.envelope
    @robot.logger.debug("repeating reminder #{idx} for #{k}")
    p = @pending[k]
    unless p
      return @idx_help "No reminders"
    i = parseInt(idx) - 1
    unless i < p.length
      return @idx_help "No such reminder to repeat"
    p[i].recurrent = true
    return "Will repeat reminder ##{i + 1}"

  add: (msg) ->
    text = msg.match[0]
    action = msg.match[2]

    chrono_result = chrono_parse text
    if not chrono_result and text.indexOf('every')
      text = text.replace 'in every', 'every in'
      chrono_result = chrono_parse text

    unless chrono_result
      msg.send "I did not understand the date in '#{text}'"
      return

    every_idx = text.indexOf('every')
    repeat = every_idx > -1 and every_idx < chrono_result.index
    date = chrono_result.start.date()

    @robot.logger.debug date
    @robot.logger.debug "repeat: #{repeat}, action: #{action}"

    reminder = new ReminderAt msg.envelope, date, action, repeat, text
    if reminder.diff() <= 0
      msg.send "#{date} is past. can't remind you"
      return

    @queue reminder
    every = if repeat then ' every' else ''
    msg.send "I'll remind you#{every} #{action} #{reminder.prettyDate()}"

class ReminderAt

  constructor: (@envelope, @date, @action, @recurrent, @text) ->

  key: ->
    envelope_key @envelope

  diff: ->
    time_until @date

  prettyDate: ->
    moment(@date).calendar()

  listing: ->
    extra = if @recurrent then " (repeated)" else ""
    "#{@action} at #{@prettyDate()}#{extra}"

  respawn: (logger) ->
    unless @recurrent and @text
      return

    chrono_result = chrono_parse @text
    unless chrono_result
      logger.warning "I did not understand the date in '#{text}'"
      return
    date = chrono_result.start.date()

    logger.debug date
    logger.debug "rescheduling action: #{@action}"

    reminder = new ReminderAt @envelope, date, @action, @recurrent, @text
    if reminder.diff() <= 0
      logger.warning "#{date} is past. can't remind you"
      return

    reminder

module.exports = (robot) ->
  reminders = new Reminders robot
  timer = 0
  interval = parseInt(process.env.EMAIL_FETCH_INTERVAL || 1)
  label = process.env.EMAIL_LABEL || "Inbox"
  client = false
  c = new cleverbot()

  robot.respond /@(.*)/i, (msg) ->
    data = msg.match[1].trim()
    cleverbot.prepare(( -> c.write(data, (c) => msg.send(c.message))))
  
  robot.respond /(hello)/i, (msg) ->
    msg.send 'Hello!'

  robot.respond /exams (.*)/i, (msg) ->
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

  
  robot.respond /Email fetch start/i, (msg) ->
    if not client
      client = initClient(msg)
      if client
        msg.send "Started the EMail fetch"
    else
      msg.send "Its already running!"

  robot.respond /Email fetch stop/i, (msg) ->
    if client
      client.close()
      client = false
      clearTimeout timer
      msg.send "Stopped the EMail fetch"

  robot.respond /email fetch change ([1-9][0-9]*)/i, (msg) ->
    clearTimeout timer
    interval = parseInt msg.match[1]
    setTimer interval, msg
    msg.send "Changed the EMail fetch interval"

  initClient = (msg) ->
    robot.logger.info "Initializing IMAP client..."
    _client = inbox.createConnection false, "qasid.iitk.ac.in", {
      secureConnection: true
      auth:
        user: process.env.HUBOT_EMAIL_USER
        pass: process.env.HUBOT_EMAIL_PWD
    }
    _client.lastfetch = 0
    _client.connect()
    _client.on 'connect', () ->
      _client.openMailbox label, (e, info) ->
        if e
          msg.send e
          return false
        robot.logger.info("Message count in #{label}: " + info.count)
        setTimer interval, msg
    return _client

  setTimer = (_interval, msg) ->
    timer = setTimeout doFetch, _interval * 60 * 1000, ((e, mail) ->
      if e
        robot.logger.info e
      else
        robot.logger.info "Get mail: ", mail.subject
        mailDetail = ""
        sender = mail.from[0]
        mailDetail += "From: #{sender.name} <#{sender.address}>\n"
        mailDetail += "Subject: #{mail.subject}\n"
        if mail.text
          mailDetail += "\n"
          mailDetail += mail.text
          par_date = /(Quiz|Exam)+ +on+ +\d{1,2}\s+(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|Jun(e)?|Jul(y)?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?)/i
          check = par_date.test(mail.text)
          if check
            check2 = par_date.exec(mail.text)
            mg = check2[0].split(' ')
            topic = mg[0]
            time = mg.shift()
            x = mg.join(' ')
            m = "remind me "+x+" to "+time
            reminders.add m
        msg.send mailDetail
      ), (() ->
        robot.logger.info "Max UID: #{client.lastfetch}"
        setTimer interval, msg
      )

  doFetch = (callback, onFinish) ->
    robot.logger.info "Check it!"
    client.listMessages -10, (e, messages) ->
      maxUID = _.max(_.map messages, (m) -> m.UID)
      if e
        callback e
      else if maxUID <= client.lastfetch
        callback(new Error "No new mail")
      else
        for message in messages
          if client.lastfetch < message.UID
            stream = client.createMessageStream(message.UID)
            mailparser = new MailParser()
            mailparser.on 'end', (mail) ->
              callback(null, mail)
            stream.pipe(mailparser)
        client.lastfetch = maxUID
      onFinish()


  robot.respond /remind (.+) ((to|for).*)/i, (msg) ->
    reminders.add msg

  robot.respond /(list|show|all)\s+remind(er|ers)?/i, (msg) ->
    msg.send reminders.list(msg)

  robot.respond /remind(er|ers)?\s+(list|show|all)/i, (msg) ->
    msg.send reminders.list(msg)

  robot.respond /remind(er|ers)?\s+(delete|remove|stop)\s+(\d+)/i, (msg) ->
    idx = msg.match[3]
    msg.send reminders.delete(msg, idx)

  robot.respond /(delete|remove|stop)\s+remind(er|ers)?\s+(\d+)/i, (msg) ->
    idx = msg.match[3]
    msg.send reminders.delete(msg, idx)

  robot.respond /remind(er|ers)?\s+(repeat)\s+(\d+)/i, (msg) ->
    idx = msg.match[3]
    msg.send reminders.repeat(msg, idx)

  robot.respond /(repeat)\s+remind(er|ers)?\s+(\d+)/i, (msg) ->
    idx = msg.match[3]
    msg.send reminders.repeat(msg, idx)
