# random.coffee
# Randomization stuff.

module.exports.string = (size) ->
    chars = "abcdefghiklmnopqrstuvwxyz1234567890ABCDEFGHIKLMNOPQRSTUVWXYZ"
    random = ""

    for s in size
        @rnum = Math.floor Math.random() * chars.length
        random += chars.substring @rnum, @rnum + 1

    return random

module.exports.number = (from, to) ->
    shuffle = []

    if to is undefined
        # From = 0
        shuffle = [0 .. from]
    else
        shuffle = [from .. to]
    
    for i in shuffle
        j = Math.floor Math.random() * (i + 1)
        tempi = shuffle[i]
        tempj = shuffle[j]
        
        shuffle[i] = tempj
        shuffle[j] = tempi
    
    return shuffle[0]