#= require ../widgets/widget

class @SlidesBrowserPage extends Widget
  bindDom: ->
    @sideview = @findParentWidgetByType('SideView')

  enhancePage: ->
    @bindActionHandlers()

  newSlides: ->
    @sideview.updateView('new-slides')

