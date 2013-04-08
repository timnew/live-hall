#= require ../widgets/widget
#= require ../widgets/SideViewWidget
#= require ./QRCodeWidget

class @HomePage extends Widget
  bindDom: ->
    @sideView = Widget.findWidgetByType('SideView')
    @homeCarousel = @element.find('#home-carousel')

  enhancePage: ->
    @homeCarousel.carousel
      interval: false
    @homeCarousel.on 'slid', (e) ->
      console.log e
    @bindActionHandlers()

  createRoom: ->
    @sideView.show().updateView('create-room')

  showLiveHall: ->
    @homeCarousel.carousel(0)
  showRoom: ->
    @homeCarousel.carousel(1)
  showSlides: ->
    @homeCarousel.carousel(2)


class @HomeNavBar extends Widget
  bindDom: ->
    @homePage = Widget.findWidgetByType('HomePage')

  enhancePage: ->
    @bindActionHandlers("[data-action-handler]", @homePage)

