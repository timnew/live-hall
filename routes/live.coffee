EventEmitter = require('events').EventEmitter

class EventSource extends EventEmitter
  

source = new EventSource()

exports.publish = (req, res) ->
  source.emit('go', req.body)
  res.send 200

exports.subscribe = (req, res) ->
  req.socket.setTimeout(Infinity)

  onMessage = (data) ->
    json = JSON.stringify(data)
    res.write "data: #{json}\n\n"
    
  source.on 'go', onMessage
    
  res.writeHead 200,
    'Content-Type': 'text/event-stream'
    'Cache-Control': 'no-cache'
    'Connection': 'keep-alive'

  res.write('\n');

  req.on "close", ->
    source.removeListener 'go', onMessage