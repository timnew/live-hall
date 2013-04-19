exports.view = (req, res) ->
  Records.Room.findById req.params.roomId, (err, room) ->

    return res.send 500, err if err?

    Records.Slides.findById room.slidesId, (err, slides) ->
      return res.send 500, err if err?

      isPresenter = !!req.query.control or req.query.control == ''

      options =
        title: "#{room.name} - #{slides.name}"
        roomId: room.id
        engine: slides.theme
        isPresenter: isPresenter
        widgetName: if isPresenter then 'SlidesPresenter' else 'SlidesViewer'
        note: !req.query.note or req.query.note == ''
        content: slides.render()

      console.log options

      res.render "#{options.engine}/view", options

exports.launch = (req, res) ->
  roomSource = Models.EventSource.getOrCreate('Room', req.params.roomId)
  roomSource.publish true, 'launched'
  exports.view(req, res)

exports.publishEvents = (req, res) ->
  slidesSource = Models.EventSource.getOrCreate('Room', req.params.roomId)
  slidesSource.publish(req.body.data, req.body.event)
  res.send 200

exports.subscribeEvents = (req, res) ->
  slidesSource = Models.EventSource.getOrCreate('Room', req.params.roomId)

  slidesSource.hookClient(req, res)
