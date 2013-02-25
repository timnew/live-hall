# = require_tree ./qrcode

$ ->
  $('[data-qrcode]').each ->
    $this = $(this)
    $this.qrcode($this.data('qrcode'))
