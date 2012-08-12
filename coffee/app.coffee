irc = require "irc"

settings = 
    server: "irc.servercentral.net"
    channel: "#dreamincode"
    nick: "Vapor"

client = new irc.Client settings.server, settings.nick,
    channels: [ settings.channel ]
    debug: true

client.addListener "connect", ->
    client.say settings.channel, "Hello, I'm just another bot! :P"

client.addListener "message" + settings.channel, (nick, msg) ->
    console.log "<#{nick}> #{msg}"

client.addListener "pm", (from, msg) ->
    console.log "PM <#{from}> #{msg}"