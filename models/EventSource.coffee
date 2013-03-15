EventEmitter = require('events').EventEmitter

class EventSource extends EventEmitter
  constructor: (@name) ->
    @clientCount = 0

  trigger: (eventData) ->
    @emit 'event', eventData

  removeListener:(event, listner)->
    super(event, listner)
    @clientCount--
    @emit('listenerRemoved')

  hookOneTimeClient: (req, res) ->
    req.socket.setTimeout(Infinity)

    onMessage = (eventData) =>
      res.write "id: #{eventData.id}" if eventData.id?
      res.write "event: #{eventData.event}" if eventData.event?
      res.write "data: #{eventData.data}\n\n"
      @clientCount--
      @emit('listenerRemoved')
      res.close()

    @once 'event', onMessageEx

    res.writeHead 200,
                  'Content-Type': 'text/event-stream'
                  'Cache-Control': 'no-cache'
                  'Connection': 'keep-alive'
    res.write('\n');

    req.on "close", =>
      @removeListener 'event', onMessage

  hookClient: (req, res) ->
    req.socket.setTimeout(Infinity)

    onMessage = @createListener(res)

    @addListener 'event', onMessage
    @clientCount++

    res.writeHead 200,
                  'Content-Type': 'text/event-stream'
                  'Cache-Control': 'no-cache'
                  'Connection': 'keep-alive'
    res.write('\n');

    req.on "close", =>
      @clientCount--
      @removeListener 'event', onMessage