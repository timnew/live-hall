EventEmitter = require('events').EventEmitter

class EventSource extends EventEmitter

source = new EventSource()

exports.publish = (req, res) ->
  console.log req.body
  source.emit('go', req.body)
  res.send 200

exports.subscribe = (req, res) ->
  req.socket.setTimeout(Infinity)

  onMessage = (message, event, id) ->
    json = JSON.stringify(message)
    res.write "id: #{id}" if id?
    res.write "event: #{event}" if event?
    res.write "data: #{json}\n\n"
    
  source.on 'go', onMessage
    
  res.writeHead 200,
    'Content-Type': 'text/event-stream'
    'Cache-Control': 'no-cache'
    'Connection': 'keep-alive'

  res.write('\n');

  req.on "close", ->
    source.removeListener 'go', onMessage