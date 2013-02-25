# = require_tree ./qrcode

$ ->
  $('[data-qrcode]').each ->
    $this = $(this)
    $this.qrcode
      text: $this.data('qrcode')
      width: 128
      height: 128

