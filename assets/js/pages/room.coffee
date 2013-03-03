#= require ../widgets/widget
#= require ../widgets/SideViewWidget
#= require ./QRCodeWidget

class @RoomPage extends Widget
  bindDom: ->
    @parts = {}
    @bindWidgetParts @parts
    @sideView = Widget.findWidgetByType('SideView')

  enhancePage: ->
    @room = @element.data('room')
    @bindActionHandlers()

  initialize: ->
    @refresh()

  refresh: ->
    @parts.nameDom.text @room.name
    @parts.descriptionDom.text @room.description
    @parts.clientCountDom.text @room.clientCount

  openPresenterView: ->
    @sideView.show().updateView('presenter')

class SharingBlock extends Widget
  bindDom: ->
    @urlBox = @element.find('#urlbox')
    @qrCodeWidget = @findSubWidgetByType('QRCode')

  enhancePage: ->
    @zeroClipboard = new ZeroClipboard $("#copy-url"),
      hoverClass: "btn-primary:hover"
      activeClass: 'active'

  initialize: ->
    @shortenUrl();

  shortenUrl: ->
    return if @urlBox.data('shorten')

    postBody =
      longUrl: @urlBox.val()

    $.postJson 'https://www.googleapis.com/urlshortener/v1/url', postBody,
       (data) =>
         @urlBox.val(data.id)
         @qrCodeWidget.update(data.id)
         @urlBox.data('shorten', true)

RoomPage
  .createNamespace()
  .register SharingBlock, 'SharingBlock'