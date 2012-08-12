irc = require "irc"

settings = 
    server: "irc.servercentral.net"
    channel: "#dreamincode"
    nick: "Vapor"
    admin: "nathanpc"

client = new irc.Client settings.server, settings.nick,
    channels: [ settings.channel ]
    userName: settings.nick
    realName: settings.nick
    showErrors: true
    debug: true

client.addListener "connect", ->
    console.log "Connected."

client.addListener "join", (channel, nick, msg) ->
    if nick is settings.nick
        client.say channel, "Hello, I'm just another bot! :P"

client.addListener "message" + settings.channel, (nick, msg) ->
    console.log "<#{nick}> #{msg}"

client.addListener "pm", (from, msg) ->
    if from is settings.admin
        @command = msg.split(" ")[0]
        console.log "ADMIN <#{from}> COMMAND: #{msg}"

        switch @command
            when "say"
                client.say settings.channel, msg.split(" ").slice(1).join(" ")
    else
        console.log "PM <#{from}> #{msg}"