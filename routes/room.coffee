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

    roomViewModel =
      name: room.name
      description: room.description
      id: room.id

    res.render 'room/room',
       room: roomViewModel
       roomUrl: buildUrl("/room/#{room.id}", req)
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
  Records.Room.findById req.params.roomId, (err, room) ->
    return res.send 500, err if err?

    links =
      note:
        viewUrl: buildUrl("/view/#{room.id}?control&note", req)
        launchUrl: buildUrl("/launch/#{room.id}?control&note", req)
      presenter:
        viewUrl: buildUrl("/view/#{room.id}?control", req)
        launchUrl: buildUrl("/launch/#{room.id}?control", req)

    if room.authInfo?
      challenge = "af4367da"
      sessionId = "123456"
      action = "presentation"
      auth = "tiqrauth://#{room.id}@com.herokuapp.live-hall/#{sessionId}+#{action}/#{challenge}?"
    else
      auth = null

    res.render 'room/presenter',
      slidesLinks: links
      auth: auth

exports.edit = (req, res) ->
  Records.Room.findByIdAndUpdate req.params.roomId, req.body, (err, room) ->
    return res.send 500, err if err?

    Models.EventSource.tapIfExists 'Slides', req.params.roomId, (source) ->
      source.publish true, 'refresh'
    res.redirect "/room/#{room.id}"

exports.edit.view = (req, res) ->
  Records.Room.findById req.params.roomId, (err, room) ->
    return res.send 500,err if err?

    Records.Slides.find().select('name').exec (err, slideses) ->
      res.render 'room/edit',
               slideses: slideses
               room: room

exports.lockdown = {}

exports.lockdown.lock = (req, res) ->
  Records.Room.findByIdAndUpdate req.params.roomId, { authInfo: req.body }, (err, room) ->
    res.send 500 if err?

    res.send 'OK'

exports.lockdown.lockMeta = (req, res) ->
  Records.Room.findById req.params.roomId, (err, room) ->
    res.send 500, err if err?

    res.send
      service:
        identifier: 'com.herokuapp.live-hall'
        displayName: 'Live Hall'
        logoUrl: 'http://nodejs.org/images/logo.png'
        infoUrl: 'http://live-hall.herokuapp.com'
        authenticationUrl: buildUrl("/room/#{room.id}/lockdown/auth", req)
        ocraSuite: "OCRA-1:HOTP-SHA1-6:QH8-S"
        enrollmentUrl: buildUrl("/room/#{room.id}/lockdown/lock", req)
      identity:
        identifier: "#{room.id}"
        displayName: "Room #{room.name}"

unlockActions =
  unlock: (req, res, room, done) ->
    room.authInfo = null
    room.save done

exports.lockdown.unlock = (req, res) ->
  Records.Room.findById req.params.roomId, (err, room) ->
    res.send 500 if err?
    ###
      { sessionKey: '123456 presentation',
      userId: '516fc6cb76dc1579c8000001',
      response: '775036',
      language: 'en',
      notificationType: 'APNS',
      notificationAddress: '0c33c0e0c015fdf5cf9f608f240693b6914bce6c' }
    ###
    [req.body.sesionId, req.body.action] = req.body.sessionKey.split(' ')

    doneCallback = (err) ->
      return res.send 500 if err?

      res.send 'OK'

    action = unlockActions[req.body.action]
    if action?
      action(req, res, room, doneCallback)
    else
      res.send 500

exports.lockdown.view = (req, res) ->
  Records.Room.findById req.params.roomId, (err, room) ->
    res.send 500, err if err?

    if room.authInfo?
      challenge = "af4367da"
      sessionId = "123456"
      action = "unlock"
      res.render 'room/lockdown',
         action: "Unlock Room #{room.name}"
         actionUrl: "tiqrauth://#{room.id}@com.herokuapp.live-hall/#{sessionId}+#{action}/#{challenge}"
    else
      enrollMetaUrl = buildUrl("/room/#{room.id}/lockdown/lock", req)
      enrollmentUri = "tiqrenroll://#{enrollMetaUrl}"
      res.render 'room/lockdown',
        action: "Lock Room #{room.name}"
        actionUrl: enrollmentUri





