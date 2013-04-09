# = require ../widgets/widget

class @NavBar extends Widget
  bindDom: ->
    @sideView = Widget.findWidgetByType('SideView')

  enhancePage: ->
    @bindActionHandlers()

  browseRoom: ->
    @sideView.show().updateView('browse-room')
  newRoom: ->
    @sideView.show().updateView('new-room')

  browseSlides: ->
    @sideView.show().updateView('browse-slides')
  newSlides: ->
    @sideView.show().updateView('new-slides')