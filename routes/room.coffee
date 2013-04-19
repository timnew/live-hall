buildUrl = (relativeUrl, req) ->
  protocol = req.header('X-Forwarded-Protocol') ? 'http'
  host = req.header('host')
  "#{protocol}://#{host}#{relativeUrl}"

Tiqr =
  enroll: (room, req) ->
    enrollMetaUrl = buildUrl("/room/#{room.id}/lockdown/lock", req)
    "tiqrenroll://#{enrollMetaUrl}"

  enrollMeta: (room, req) ->
    {
    service:
      identifier: 'com.herokuapp.live-hall'
      displayName: 'Live Hall'
      logoUrl: 'http://nodejs.org/images/logo.png'
      infoUrl: 'http://live-hall.herokuapp.com'
      authenticationUrl: buildUrl("/room/#{room.id}/lockdown/unlock", req)
      ocraSuite: "OCRA-1:HOTP-SHA1-6:QH8-S"
      enrollmentUrl: buildUrl("/room/#{room.id}/lockdown/lock", req)
    identity:
      identifier: "#{room.id}"
      displayName: "Room #{room.name}"
    }

  challenge: (room, sessionId, action) ->
    sessionId = sessionId.replace(/\+/g,'-').replace(/\//g,'_')
    challenge = 'af4367da'
    "tiqrauth://#{room.id}@com.herokuapp.live-hall/#{sessionId}+#{action}/#{challenge}/LiveHall"

exports.list = (req, res) ->
  Records.Room.find (err, rooms) ->
    res.render 'room/list',
       rooms: rooms

exports.get = (req, res) ->
  Records.Room.findById req.params.roomId, (err, room) ->
    res.send 500, err if err?

    res.render 'room/room',
       room:
         id: room.id
         sessionId: req.sessionID
         name: room.name
         description: room.description
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

    if room.authInfo?
      authPrefix = Tiqr.challenge(room, req.sessionID, 'presentation')
      authRequired = true
      authedOrOpen = req.sessionID == room.authedSession
    else
      authPrefix = null
      authRequired = false
      authedOrOpen = true

    res.render 'room/presenter',
      slidesLinks:
        note:
          viewUrl: buildUrl("/view/#{room.id}?control&note", req)
          launchUrl: buildUrl("/launch/#{room.id}?control&note", req)
        presenter:
          viewUrl: buildUrl("/view/#{room.id}?control", req)
          launchUrl: buildUrl("/launch/#{room.id}?control", req)
      authPrefix: authPrefix
      authRequired: authRequired
      authedOrOpen: authedOrOpen

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

exports.lockdown =
  lock: (req, res) ->
    Records.Room.findByIdAndUpdate req.params.roomId, { authInfo: req.body }, (err, room) ->
      res.send 500 if err?

      roomSource = Models.EventSource.getOrCreate('Room', req.params.roomId)

      roomSource.publish true, 'refresh' #enforce all client to refresh

      res.send 'OK'

  lockMeta: (req, res) ->
    Records.Room.findById req.params.roomId, (err, room) ->
      res.send 500, err if err?

      metaData = Tiqr.enrollMeta(room, req)
      console.log metaData
      res.send metaData

  view: (req, res) ->
    Records.Room.findById req.params.roomId, (err, room) ->
      res.send 500, err if err?

      if room.authInfo?
        if req.sessionID == room.authedSession
          action = "unlock"
        else
          action = "auth"

        res.render 'room/unlock',
                   title: "Unlock Room #{room.name}"
                   actionUrl: Tiqr.challenge(room, req.sessionID, action)
      else
        res.render 'room/lock',
                   roomName: room.name
                   actionUrl: Tiqr.enroll(room, req)

  unlock: (req, res) ->
    Records.Room.findById req.params.roomId, (err, room) ->
      res.send 500 if err?

      [req.body.sessionId, req.body.action] = req.body.sessionKey.split(' ')
      req.body.sessionId = req.body.sessionId.replace(/-/g,'+').replace(/_/g,'/')

      doneCallback = (err) ->
        return res.send 500 if err?
        res.send 'OK'

      action = unlockActions[req.body.action]
      if action?
        console.log "Unlock action: #{req.body.action}"
        action(req, res, room, doneCallback)
      else
        res.send 500

unlockActions =
  unlock: (req, res, room, done) ->
    room.authInfo = null
    room.authedSession = null

    room.save (err) ->
      return done(err) if err?

      roomSource = Models.EventSource.getOrCreate('Room', req.params.roomId)
      roomSource.publish true, 'refresh'
      done()

  auth: (req, res, room, done) ->
    oldSession = room.authedSession
    room.authedSession = req.body.sessionId

    room.save (err) ->
      return done(err) if err?

      roomSource = Models.EventSource.getOrCreate('Room', req.params.roomId)
      roomSource.notify oldSession, true, 'refresh'
      roomSource.notify room.authedSession, 'presenter', 'updateView'

      done()

  presentation: (req, res, room, done) ->
    #TODO setup temp auth url, and redirect user there.
    done()

