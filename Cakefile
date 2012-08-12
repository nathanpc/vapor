spawn = require("child_process").spawn
color = require("ansi-color").set

task "build", "Compile all the CoffeeScript source codes", (options) ->
    coffee = spawn "coffee", [ "-co", "./", "coffee/" ]
    
    console.log color("Compiling Source Codes...", "green")
    
    coffee.stdout.setEncoding "utf8"
    coffee.stdout.on "data", (data) ->
        process.stdout.write data
    
    coffee.stderr.setEncoding "utf8"
    coffee.stderr.on "data", (data) ->
        process.stdout.write color("ERROR: ", "bold+red") + data
    
    coffee.on "exit", (code) ->
        if code != 0
            console.log color("Failed: ", "red") + code
        else
            console.log color("Source Code Compiled!", "green")

task "watch", "Watch a file for changes, and recompile it every time the file is saved", (options) ->
    coffee = spawn "coffee", [ "--watch", "-co", "./", "coffee/" ]

    console.log color("Watching Source Codes...", "green")

    coffee.stdout.setEncoding "utf8"
    coffee.stdout.on "data", (data) ->
        process.stdout.write data
    
    coffee.stderr.setEncoding "utf8"
    coffee.stderr.on "data", (data) ->
        process.stdout.write color("ERROR: ", "bold+red") + data

    coffee.on "exit", (code) ->
        if code != 0
            console.log color("Failed: ", "red") + code
        else
            console.log color("Finished Watching.", "green")