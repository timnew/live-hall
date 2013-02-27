#= require ./widget

class SideShow extends Widget
  transitionOptions:
    direction: 'right'
    easing: 'easeOutCirc'

  enhancePage: ->
    $(document).keyup @escapePressed
    @element.on 'click', '.close[data-dismiss="sideshow"]', =>
      @hide()

  isOpen: ->
    @element.is(':visible')

  escapePressed: (e) =>
    if (e.keyCode == 27)
      if @isOpen()
        e.preventDefault()
        e.stopPropagation()
        @hide()

  show: ->
    @backdrop ?= $('<div class="sideshow-backdrop hide">').appendTo($('body')).show('fade', 1000)
    @element.show 'slide', @transitionOptions, 1000

  hide: ->
    if @backdrop?
      @backdrop.hide 'fade', 1000, =>
        @backdrop.remove()
        @backdrop = null
    @element.hide 'slide', @transitionOptions, 1000

Widget.register SideShow, 'SideShow'