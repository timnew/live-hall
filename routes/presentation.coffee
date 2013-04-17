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
        content: slides.render()

      console.log options

      res.render "#{options.engine}/view", options

exports.launch = (req, res) ->
  roomSource = Models.EventSource.getOrCreate('Room', req.params.roomId)
  roomSource.publish true, 'launched'
  exports.view(req, res)

exports.status = (req, res) ->
  roomSource = Models.EventSource.getOrCreate('Room', req.params.roomId)
  roomSource.hookClient(req, res)

exports.publishEvents = (req, res) ->
  console.log req.params.roomId, req.body
  slidesSource = Models.EventSource.getOrCreate('Slides', req.params.roomId)
  slidesSource.publish(req.body.data, req.body.event)
  res.send 200

exports.subscribeEvents = (req, res) ->
  roomSource = Models.EventSource.getOrCreate('Room', req.params.roomId)

  slidesSource = Models.EventSource.getOrCreate('Slides', req.params.roomId)

  updateStatus = ->
    console.log 'clientChanged', slidesSource.reference
    roomSource.publish slidesSource.reference, 'clientChanged'

  slidesSource.on 'newListener', updateStatus
  slidesSource.on 'removeListener', updateStatus

  slidesSource.hookClient(req, res)
