EventEmitter = require('events').EventEmitter
_ = require('underscore')

class EventSource extends EventEmitter
  constructor: (@id) ->

    EventSource.register @id, this
    @reference = 0
    @messageId = 0

  sustain: ->
    @reference++

  release: ->
    @reference--

  hookClient: (req, res) ->
    req.socket.setTimeout(Infinity)

    onMessage = (message, event, id) ->
      json = JSON.stringify(message)
      res.write "id: #{id}\n" if id?
      res.write "event: #{event}\n" if event?
      res.write "data: #{json}\n\n"

    @addListener 'data', onMessage
    @sustain()

    res.writeHead 200,
                  'Content-Type': 'text/event-stream'
                  'Cache-Control': 'no-cache'
                  'Connection': 'keep-alive'
    res.write('\n');

    req.on "close", =>
      @removeListener 'data', onMessage
      @release()

  publish: (message, event, id) ->
    id ?= @messageId++

    @emit 'data', message, event, id

EventSource.sources = {}

EventSource.register = (id, instance) ->
  EventSource.sources[id] = instance

EventSource.unregister = (id) ->
  delete EventSource.sources[id]

EventSource.getOrCreate = (type, name) ->
  type = type.constructor.name if typeof(type) is 'object'

  id = "#{type}:#{name}"

  EventSource.sources[id] ? new EventSource(id)

exports = module.exports = EventSource


