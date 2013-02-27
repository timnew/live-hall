#= require ./widgets/QRCodeWidget

#= require ./widgets/widget

class @RoomPage extends Widget

class SharingBlock extends Widget
  bindDom: ->
    @urlBox = @element.find('#urlbox')
    @qrCodeWidget = @findSubWidgetByType('QRCode')

  enhancePage: ->
#    @bindActionHandlers()
    @zeroClipboard = new ZeroClipboard $("#copy-url"),
      hoverClass: "btn-primary:hover"
      activeClass: 'active'

  initialize: ->
    @shortenUrl();

#  copyUrl: =>
#    zeroClipboard.copyText @urlBox.val()

  shortenUrl: ->
    return if @urlBox.data('shorten')

    postBody =
      longUrl: @urlBox.val()

    $.postJson 'https://www.googleapis.com/urlshortener/v1/url', postBody,
       (data) =>
         @urlBox.val(data.id)
         @qrCodeWidget.update(data.id)
         @urlBox.data('shorten', true)


RoomPage.register SharingBlock, 'SharingBlock'