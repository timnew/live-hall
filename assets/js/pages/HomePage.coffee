#= require ../widgets/widget
#= require ../widgets/SideViewWidget
#= require ../widgets/QRCodeWidget

class @HomePage extends Widget
  bindDom: ->
    @sideView = Widget.findWidgetByType('SideView')
    @homeCarousel = @element.find('#home-carousel')

  enhancePage: ->
    @homeCarousel.carousel
      interval: false

    @bindActionHandlers()

  browseRoom: ->
    @sideView.show().updateView('browse-room')
  newRoom: ->
    @sideView.show().updateView('new-room')

  browseSlides: ->
    @sideView.show().updateView('browse-slides')
  newSlides: ->
    @sideView.show().updateView('new-slides')

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

