#= require ../widgets/QRCodeWidget
#= require ../widgets/SideViewWidget

#= require ../widgets/widget

class @HomePage extends Widget
  bindDom: ->
    @sideView = Widget.findWidgetByType('SideView')
    @homeCarousel = @element.find('#home-carousel')

  enhancePage: ->
    @homeCarousel.carousel()
    @bindActionHandlers()

  createRoom: ->
    @sideView.show().updateView('create-room')
