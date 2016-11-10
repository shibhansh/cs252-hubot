GoogleNews = require('google-news')
google = new GoogleNews

track = undefined

module.exports = (robot) ->
    robot.respond /search news about (.*)/i, (msg) ->
        track = msg.match[1]
        google.stream track, (stream) ->
            stream.on GoogleNews.DATA, (data) ->
                msg.send 'Headline: ' + data.title
            stream.on GoogleNews.ERROR, (error) ->
                msg.send 'Error! ' + error
