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

    console.log "Session Id: #{req.sessionID}"
    onMessage = (message, event, id) ->
      console.log "Deliver: <#{req.sessionID}>@[#{event}](#{id}) #{message}"
      json = JSON.stringify(message)
      res.write "id: #{id}\n" if id?
      res.write "event: #{event}\n" if event?
      res.write "data: #{json}\n\n"

    @sustain()
    @addListener 'publish', onMessage
    @addListener "#{req.sessionID}", onMessage

    res.writeHead 200,
                  'Content-Type': 'text/event-stream'
                  'Cache-Control': 'no-cache'
                  'Connection': 'keep-alive'
    res.write('\n');

    req.on "close", =>
      @release()
      @removeListener 'data', onMessage
      @removeListener "#{req.sessionID}", onMessage


  publish: (message, event, id) ->
    id ?= @messageId++

    console.log "Publish: [#{event}](#{id}) #{message}"
    @emit 'publish', message, event, id

  notify: (sessionId, message, event, id) ->
    id ?= @messageId++

    console.log "Notify: <#{sessionId}>@[#{event}](#{id}) #{message}"
    @emit "#{sessionId}", message, event, id

EventSource.sources = {}

EventSource.register = (id, instance) ->
  EventSource.sources[id] = instance

EventSource.unregister = (id) ->
  delete EventSource.sources[id]

getId = (type, name) ->
  type = type.constructor.name if typeof(type) is 'object'

  "#{type}:#{name}"

EventSource.get = (type, name) ->
  id = getId(type, name)
  EventSource.sources[id]

EventSource.getOrCreate = (type, name) ->
  id = getId(type, name)
  EventSource.sources[id] ? new EventSource(id)

EventSource.tapIfExists = (type, name, action) ->
  source = @get(type, name)

  if source?
    action(source)

exports = module.exports = EventSource


