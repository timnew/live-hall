buildUrl = (relativeUrl, req) ->
  protocol = req.header('X-Forwarded-Protocol') ? 'http'
  host = req.header('host')
  "#{protocol}://#{host}#{relativeUrl}"

exports.get = (req, res) ->
  room = Models.Room.get(req.params.roomId)

  res.send(404) unless room?

  console.log room

  viewModel =
    roomId: room.id
    roomName: room.name
    roomDescription: room.description
    viewUrl: buildUrl("/view/#{room.id}", req)
    controlUrl: buildUrl("/view/#{room.id}?control", req)
    clientCount: room.clientCount

  res.render 'room/room', viewModel

exports.create = (req, res) ->
  room = new Models.Room(req.body)

  res.redirect "/room/#{room.id}"

exports.create.view = (req, res) ->
  res.render "room/create",
    roomId: Models.Room.newRoomId()

exports.presenterView = (req, res) ->
  res.render 'room/presenterView'

exports.public = (req, res) ->
  res.render 'room/list',
    title: 'Public Rooms'
    rooms: Models.Room.rooms

