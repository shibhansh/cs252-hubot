notes = []
module.exports = (robot) ->
  robot.brain.on 'loaded', ->
    notes = robot.brain.data.notes or []
  robot.respond /add note (.*)/i, (msg) ->
    note = msg.match[1]
    notes.push(note)
    robot.brain.data.notes = notes 
    msg.send "Successfully added note"
  robot.respond /show notes/i, (msg)->
    i = 1
    data = ""
    len = notes.length
    while i <= len
      data += i+". "+notes[i-1]+"\n"
      i++
    msg.send data
  robot.respond /delete note (.*)/i, (msg)->
    id = msg.match[1]
    pat = /\d/
    check = pat.test(id)
    if check and id<=notes.length
      notes.splice(id-1, 1)
      robot.brain.data.notes = notes
      msg.send "Deleted Successfully"
    else
      msg.send "Please provide valid id"