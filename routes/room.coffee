buildUrl = (relativeUrl, req) ->
  protocol = req.header('X-Forwarded-Protocol') ? 'http'
  host = req.header('host')
  "#{protocol}://#{host}#{relativeUrl}"

checkAuth = Routes.auth.checkAuth

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

exports.create = (req, res) ->
  room = new Models.Room(req.body)

  res.redirect "/room/#{room.id}"

exports.create.view = (req, res) ->
  res.render "room/create",
    roomId: Models.Room.newRoomId()

exports.presenter = (req, res) ->
  room =
    id: req.params.roomId
  res.render 'room/presenter',
    roomId: room.id
    controlUrl: buildUrl("/view/#{room.id}?control", req)
    noteUrl: buildUrl("/view/#{room.id}?control&note", req)

exports.edit = checkAuth (req, res) ->
  room = Models.Room.get(req.params.roomId)
  room.updateModel(req.body)
  res.redirect "/room/#{req.params.roomId}"

exports.edit.view = checkAuth (req, res) ->
  room = Models.Room.get(req.params.roomId)

  res.render 'room/edit',
     room: room
