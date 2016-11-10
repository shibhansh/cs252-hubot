module.exports = (robot) ->
  robot.respond /shutdown$/i, (msg) ->
    msg.send 'See you!'
    msg.robot.shutdown()