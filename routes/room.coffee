buildUrl = (relativeUrl, req) ->
  protocol = req.header('X-Forwarded-Protocol') ? 'http'
  host = req.header('host')
  "#{protocol}://#{host}#{relativeUrl}"

exports.public = (req, res) ->
  res.render 'room/list',
     title: 'Public Rooms'
     rooms: Models.Room.rooms

exports.get = (req, res) ->
  room = Models.Room.get(req.params.roomId)

  res.send(404) unless room?

  console.log room

  res.render 'room/room',
    room: room
    viewUrl: buildUrl("/view/#{room.id}", req)
    controlUrl: buildUrl("/view/#{room.id}?control", req)

exports.create = (req, res) ->
  room = new Models.Room(req.body)

  res.redirect "/room/#{room.id}"

exports.create.view = (req, res) ->
  res.render "room/create",
    roomId: Models.Room.newRoomId()

exports.login = (req, res) ->
  res.send(200)

exports.login.view = (req, res) ->
  res.send(200)

exports.presenter = (req, res) ->
  res.send(200)

exports.edit = (req, res) ->
  res.send 200

exports.edit.view = (req, res) ->
  room = Models.Room.get(req.params.roomId)

  res.render 'room/edit',
     room: room
