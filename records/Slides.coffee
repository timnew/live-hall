SlidesSchema = new Services.Repository.Schema
  name: String
  theme: String
  format: String
  content: String

SlidesSchema.methods.render = ->
  switch @format
    when 'jade'
      require('jade').compile(@content)()
    when 'html'
      @content


Slides = Services.Repository.model 'Slides', SlidesSchema

module.exports = Slides

