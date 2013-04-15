exports.list = (req, res) ->
  Records.Slides.find().exec (err, slideses) ->
    res.render 'slides/list',
      slideses: slideses

exports.new = (req, res) ->
  console.log req.body

  Records.Slides.create req.body, (err, slides) ->
    if err?
      res.send 500,
               status: 'error'
               exception: err
    else
      res.send 200,
               status: 'ok'


exports.new.view = (req, res) ->
  res.render('slides/new')

exports.edit = (req, res) ->
  Records.Slides.findByIdAndUpdate req.params.slidesId, req.body, (err, slides) ->
    if err?
      res.send 500,
               status: 'error'
               exception: err
    else
      res.send 200,
               status: 'ok'

exports.edit.view = (req, res) ->
  Records.Slides.findById req.params.slidesId, (err, slides) ->
    res.render 'slides/edit',
      slides: slides

