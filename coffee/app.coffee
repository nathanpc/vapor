irc = require "irc"

# Modules
crypt_hash = require "./modules/crypt_hash.js"
random = require "./modules/random.js"

settings = 
    server: "irc.servercentral.net"
    channel: "#dreamincode"
    nick: "Vapor"
    admin: "nathanpc"
    welcome: "Fuck this shit. I'm fucking awesome."

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
        # Has welcome message?
        if settings.welcome isnt ""
            client.say settings.channel, settings.welcome
    else
        # User joined.
        console.log "JOIN <#{channel}>: #{nick}"

client.addListener "part", (channel, nick, msg) ->
    # User parted.
    console.log "PART <#{channel}>: #{nick}"

client.addListener "message" + settings.channel, (nick, msg) ->
    # Check if it's a command or not.
    if msg[0] is "@"
        @command = msg.split(" ")[0].slice(1)
        
        switch @command
            when "random"
                @arg = msg.split(" ")[1]
                
                if @arg is "s"
                    client.say settings.channel, random.string msg.split(" ")[2]
                else if @arg is "n"
                    client.say settings.channel, random.number msg.split(" ")[2], msg.split(" ")[3]
                else
                    client.say settings.channel, "You must declare a valid argument to generate random stuff. USAGE: \"random $arg $...\""
                    client.say settings.channel, "Valid arguments: s = String / n = Number"
            when "md5"
                @md5 = crypt_hash.md5 msg.split(" ").slice(1).join(" ")
                client.say settings.channel, @md5
    else
        console.log "<#{nick}> #{msg}"

client.addListener "pm", (from, msg) ->
    # Check it it's a admin command
    if from is settings.admin
        @command = msg.split(" ")[0]
        console.log "<#{from}> COMMAND: #{msg}"

        switch @command
            when "say"
                client.say settings.channel, msg.split(" ").slice(1).join(" ")
            when "disconnect"
                client.disconnect "Vapor Bot by nathanpc <http://github.com/nathanpc/vapor>", ->
                    process.exit 0
    else
        client.say from, "Unauthorized Command."
        console.log "UNAUTHORIZED PM: <#{from}> #{msg}"