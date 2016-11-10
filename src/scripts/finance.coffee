request = require('request')
callback = (error, response, body) ->
	if !error and response.statusCode == 200
		console.log body
	return

module.exports = (robot) ->
	robot.respond /finance +\d+(.*)/i, (msg) ->
		sh = msg.match[0]
		sheet_par = sh.split(" ")
		amount = sheet_par[2]
		temp = sheet_par.shift()
		temp = sheet_par.shift()
		temp = sheet_par.shift()
		reason = sheet_par.join(" ")
		urls = "https://docs.google.com/forms/d/e/1FAIpQLSdLLEJXp_jKxjjGTaEYotCnfzKKT9yRkREoyN8Xm5WCsC1B5A/formResponse?entry.1712859746="+amount+"&entry.1479987058="+reason+"&submit=Submit"
		options = 
			url: urls
			method: 'POST'
		request options, callback
		msg.send "Added succesfully"