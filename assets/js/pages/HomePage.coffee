#= require ../widgets/widget
#= require ../widgets/SideViewWidget
#= require ./QRCodeWidget

class @HomePage extends Widget
  bindDom: ->
    @sideView = Widget.findWidgetByType('SideView')
    @homeCarousel = @element.find('#home-carousel')

  enhancePage: ->
    @homeCarousel.carousel()
    @bindActionHandlers()

  createRoom: ->
    @sideView.show().updateView('create-room')
