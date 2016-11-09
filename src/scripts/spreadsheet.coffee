spreadsheet = require('google-spreadsheet')
doc = new spreadsheet('sheet key')                          #IMPORTANT: Spreadsheet key has to be fed into this instance
sheet = undefined

setAuth = (msg, step) ->
  creds = require('./google-generated-credentials.json')    #IMPORTANT: Needs google generated credentials from google console developer
  doc.useServiceAccountAuth creds, step
  msg.send "Authenticated! Can access the doc..."
  return

getInfo = (msg, step) ->
  doc.getInfo (err, info) ->
    #console.log 'Loaded doc: ' + info.title + ' by ' + info.author.email
    title = info.title
    email = info.author.email
    msg.send "Loaded doc: " + title + "by" + email
    sheet = info.worksheets[0]
    #console.log 'sheet 1: ' + sheet.title + ' ' + sheet.rowCount + 'x' + sheet.colCount
    msg.send "sheet 1: " + sheet.title + " " + sheet.rowCount + "x" + sheet.colCount
    step()
    return
  return

getRows = (msg, step) ->
  sheet.getRows {
    offset: 1
    limit: 20
    orderby: 'col2'
  }, (err, rows) ->
    msg.send 'Read ' + rows.length + ' rows'
    step()
    return
  return

getCells = (msg, step) ->
  sheet.getCells {
    'min-row': 1
    'max-row': 5
    'return-empty': true
  }, (err, cells) ->
    cell = cells[0]
    msg.send 'Cell R' + cell.row + 'C' + cell.col + ' = ' + cells.value
    cells[0].value = 1
    cells[1].value = 2
    cells[2].formula = '=A1+B1'
    sheet.bulkUpdateCells cells
    #async
    step()
    return
  return

setTitle = (msg, step, title) ->
    sheet.setTitle title
    step()
    return

managingSheets = (msg, step) ->
  doc.addWorksheet { title: 'my new sheet' }, (err, sheet) ->
    step()
    return
  return

module.exports = (robot) ->
    robot.respond /aunthenticate(.*)/i, (msg) ->
        setAuth msg, step

    robot.respond /getInfo/,i (msg) ->
        getInfo msg, step

    robot.respond /getRows/,i (msg) ->
        getRows msg, step

    robot.respond /getCells/,i (msg) ->
        getRows msg, step

    robot.respond /set title (.*)/,i (msg) ->
        title = msg.match[1]
        getTitle msg, step, title
