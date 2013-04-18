#= require ./RevealJsViewer

class @SlidesPresenter extends SlidesViewer
  isPresenter: true

  enhancePage: ->
    super()
    Reveal.addEventListener 'slidechanged', @onSlideChanged

  onSlideChanged: (e) =>
    @publish 'slidesProgress',
      h: e.indexh
      v: e.indexv