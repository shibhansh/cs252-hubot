htmlToText = require('html-to-text')
url = "http://172.26.142.68/examscheduler2/personal_schedule.php?rollno="
module.exports = (robot) ->
	robot.respond /exam (.*)/i, (msg) ->
		roll = msg.match[1]
		fetch = url+roll
		msg.http(fetch) .get() (err, res, body) ->
			text = htmlToText.fromString("#{body}", tables: ['.contenttable_lmenu'], wordwrap: 50)
			msg.send text