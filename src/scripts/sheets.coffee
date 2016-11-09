spreadsheet = require('google-spreadsheet')

#Your spreadsheet key should be given here
doc = new spreadsheet('your-key')
sheet = undefined

class GoogleSheets

setAuthentication : (step, msg) ->
    #************These require the credentials provided by the google developer console!******
    creds = require('./google-generated-credentials-by-you.json')
    #************If these are not provided the script won't work******************************
    doc.useServiceAccountAuth creds, step
    @robot.logger.debugger("Authenicated! Can now access the doc....")
    return

getInfo = (step) ->
    doc.getInfo (err, info) ->
       @robot.


module.exports = (robot) ->
    robot.respond /(Authenticate)/i, (msg) ->
        msg.send GoogleSheets.setAuthentication(step, msg)

    robot.respond /(GetInfo)/i, (msg) ->
        getInfo step ->
        msg.send "Loaded doc: "
