SlidesSchema = new Services.Repository.Schema
  name: String
  theme: String
  format: String
  content: String

Slides = Services.Repository.model 'Slides', SlidesSchema

module.exports = Slides