#viewEngines = # TODO remove this
#  'deck': 'deckjs'
#  'deckjs': 'deckjs'
#  'reveal': 'revealjs'
#  'revealjs': 'revealjs'

exports.index = (req, res) ->
  options =
    roomId: req.params['roomId']
    engine: 'deckjs'
    control: !!req.query.control or req.query.control == ''

  console.log options

  res.render "#{options.engine}/view", options