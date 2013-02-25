buildUrl = (relativeUrl, req) ->
  protocol = req.header('X-Forwarded-Protocol') ? 'http'
  host = req.header('host')
  "#{protocol}://#{host}#{relativeUrl}"

exports.get = (req, res) ->
  room = Models.Room.get(req.params.roomId)
  viewModel =
    roomId: room.id
    viewUrl: buildUrl("/view/#{room.id}", req)
    controlUrl: buildUrl("/view/#{room.id}?control", req)
    clientCount: room.clientCount

  res.render 'room', viewModel

exports.create = (req, res) ->
  room = Models.Room.create()
  res.redirect "/room/#{room.id}"

exports.public = (req, res) ->
  res.send 200