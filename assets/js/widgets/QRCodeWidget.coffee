# = require ./widget
# = require_tree ../qrcode

class QRCodeWidget extends Widget
  bindDom: ->
    @data = @element.data('qrcode')

  initialize: ->
    @refresh()

  update: (data, size) ->
    @data = data
    @refresh(size)

  detectSize: ->
    Math.min(@element.width(), @element.height())

  refresh: (size) ->
    return unless @data?

    size = @detectSize() unless size?

    params =
      width: size
      height: size
      text: @data

    params.foreground = @element.data('color') if @element.data('color')?

    @element.html('') # Remove last one
    @element.qrcode params

Widget.register QRCodeWidget, 'QRCode'