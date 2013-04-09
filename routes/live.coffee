exports.publish = (req, res) ->
  console.log req.params.roomId, req.body

  room = Models.EventSource.getOrCreate('Room', req.params.roomId)
  room.publish(req.body)
  res.send 200

exports.subscribe = (req, res) ->
  room = Models.EventSource.getOrCreate('Room', req.params.roomId)
  room.hookClient(req, res)
