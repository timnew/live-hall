#= require ../widgets/widget

class @SlidesBrowserPage extends Widget
  bindDom: ->
    @sideview = @findParentWidgetByType('SideView')

  enhancePage: ->
    @bindActionHandlers()

  newSlides: ->
    @sideview.updateView('new-slides')

  editSlides: (e) ->
    slidesId = $(e.target).closest('a').data('slides')
    @sideview.updateViewFromUrl("/slides/#{slidesId}/edit", "new-slides")

