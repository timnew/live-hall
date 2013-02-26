# = require ./widget
# = require_tree ../qrcode

class QRCodeWidget extends Widget
  options:
    width: 128
    height: 128

  bindDom: ->
    @data = @element.data('qrcode')

  initialize: ->
    @refresh()

  update: (data) ->
    @data = data
    @refresh()

  updateSize: (size) ->
    $.extend @options,
      width: size
      height: size

    @refresh()

  refresh: ->
    return unless @data?

    params = $.extend {}, @options,
      text: @data

    @element.qrcode params

Widget.register QRCodeWidget, 'QRCode'