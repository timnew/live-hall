#= require ./DeckJsViewer

class @SlidesPresenter extends SlidesViewer
  enhancePage: ->
    super()
    $(document).bind('deck.change', @onSlideChanged)

  onSlideChanged: (event, from, to) =>
    return unless @currentPage != to

    @currentPage = to

    @publish 'slidesProgress',
      from: from
      to: to