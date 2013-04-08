exports.list = (req, res) ->
  Records.Slides.find().select('name').exec (err, slideses) ->
    console.log slideses
    res.render 'slides/list',
      slideses: slideses

exports.new = (req, res) ->
  console.log req.body

  Records.Slides.create req.body, (err) ->
    if err?
      res.send 500, err
    else
      res.redirect '/slides'

exports.new.view = (req, res) ->
  res.render('slides/new')