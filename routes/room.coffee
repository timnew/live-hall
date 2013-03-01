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

  res.render 'room/room', viewModel

exports.create = (req, res) ->
  roomId = Models.Room.newRoomId()
  res.redirect "/room/#{roomId}"

exports.create.view = (req, res) ->
  res.render "room/create"


exports.public = (req, res) ->
  res.send 200

exports.presenterView = (req, res) ->
  res.render 'room/presenterView'

