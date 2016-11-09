#Configuration
#   none
#
#
#Commands
#   hubot google-news - display the google news
module.exports = (robot)->
    require('hubot-arm') robot

    robot.respond /google-news$/i, (res) ->
        url = 'https://news.google.co.in/'
        res
            .robot
            .arm('request')
                method: 'GET'
                url: url
                format: 'html'
            .then (r) ->
                articles = []
                r.$('.esc-lead-article-title a.article').each->
                    e = r.$ @
                    href = e.attr('href')
                    title = e.text()
                    article = "#{title} #{href}"
                    articles.push article
                res.send articles.filter((item, i) -> i < 10).join('\n')
