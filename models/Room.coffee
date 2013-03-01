EventEmitter = require('events').EventEmitter

class Room extends EventEmitter
  constructor: (@id) ->
    @clientCount = 0

  hookClient: (req, res) ->
    req.socket.setTimeout(Infinity)

    onMessage = (message, event, id) ->
      json = JSON.stringify(message)
      res.write "id: #{id}" if id?
      res.write "event: #{event}" if event?
      res.write "data: #{json}\n\n"


    @addListener 'go', onMessage
    @clientCount++

    res.writeHead 200,
      'Content-Type': 'text/event-stream'
      'Cache-Control': 'no-cache'
      'Connection': 'keep-alive'
    res.write('\n');

    req.on "close", =>
      @clientCount--
      @removeListener 'go', onMessage

rooms = Room.rooms = {}

Room.newRoomId = ->
  Date.now().toString()

Room.get = (roomId) ->
  rooms[roomId] ?= new Room(roomId)

exports = module.exports = Room
