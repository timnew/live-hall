exports.publish = (req, res) ->
  console.log req.params.roomId, req.body

  room = Models.Room.get(req.params.roomId)
  room.emit('go', req.body)

  res.send 200

exports.subscribe = (req, res) ->
  console.log req.params
  room = Models.Room.get(req.params.roomId)
  room.hookClient(req, res)
