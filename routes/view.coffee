exports.index = (req, res) ->
  room = Models.Room.get req.params['roomId']

  Records.Slides.findById room.slidesId, (err, slides) ->
    return res.send 500, err if err?

    options =
      roomId: room.id
      engine: slides.theme
      control: !!req.query.control or req.query.control == ''
      content: slides.content

    console.log options

    res.render "#{options.engine}/view", options