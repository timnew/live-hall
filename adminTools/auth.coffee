exports = module.exports =
  unlock: (id) ->
    Records.Room.findById id, (err, room) ->
      return console.error err if err?
      room.unlock()

  unlockAll: ->
    Records.Room.find (err, rooms) ->
      return console.error err if err?
      room.unlock() for room in rooms

