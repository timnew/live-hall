buildUrl = (relativeUrl, req) ->
  protocol = req.header('X-Forwarded-Protocol') ? 'http'
  host = req.header('host')
  "#{protocol}://#{host}#{relativeUrl}"

exports.list = (req, res) ->
  Records.Room.find (err, rooms) ->
    res.render 'room/list',
       rooms: rooms

exports.get = (req, res) ->
  Records.Room.findById req.params.roomId, (err, room) ->
    res.send 500, err if err?

    console.log room

    res.render 'room/room',
       room: room
       viewUrl: buildUrl("/view/#{room.id}", req)

exports.new = (req, res) ->
  console.log req.body
  Records.Room.create req.body, (err, room) ->
    return res.send 500, err if err?

    res.redirect "/room/#{room.id}"

exports.new.view = (req, res) ->
  Records.Slides.find().select('name').exec (err, slideses) ->
    res.render "room/new",
      slideses: slideses

exports.presenter = (req, res) ->
  room =
    id: req.params.roomId

  links =
    note:
      localUrl: buildUrl("/view/#{room.id}?control&note", req)
      mobileUrl: buildUrl("/view/#{room.id}?control&note", req)
    presenter:
      localUrl: buildUrl("/view/#{room.id}?control", req)
      mobileUrl: buildUrl("/view/#{room.id}?control", req)

  res.render 'room/presenter',
    slidesLinks: links

exports.edit = (req, res) ->
  console.log req.body
  Records.Room.findByIdAndUpdate req.params.roomId, req.body, (err, room) ->
    return res.send 500, err if err?

    res.redirect "/room/#{room.id}"

exports.edit.view = (req, res) ->
  Records.Room.findById req.params.roomId, (err, room) ->
    return res.send 500,err if err?

    Records.Slides.find().select('name').exec (err, slideses) ->
      res.render 'room/edit',
               slideses: slideses
               room: room
