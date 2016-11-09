module.exports = (robot) ->
  robot.respond /shutdown$/i, (res) ->
    res.send 'See you!'
    res.robot.shutdown()