EventEmitter = require('events').EventEmitter
_ = require('underscore')

class Room extends EventEmitter
  constructor: (data) ->
    @clientCount = 0

    data = _.pick data, 'id', 'name', 'description'
    _.extend this, data
    console.log "data", data

    Room.rooms[@id] = this
    console.log "created", this

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

Room.rooms = {}

Room.newRoomId = ->
  Date.now().toString()

Room.get = (roomId) ->
  Room.rooms[roomId]

exports = module.exports = Room
