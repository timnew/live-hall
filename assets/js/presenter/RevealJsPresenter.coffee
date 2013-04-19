#= require ./RevealJsViewer

class @SlidesPresenter extends SlidesViewer
  isPresenter: true

  enhancePage: ->
    super()
    Reveal.addEventListener 'slidechanged', @onSlideChanged

  onSlideChanged: (e) =>
    @publishEvent 'slidesProgress',
      h: e.indexh
      v: e.indexv