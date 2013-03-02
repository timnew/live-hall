#= require ./widget

class @SideShow extends Widget
  transitionOptions:
    direction: 'right'
    easing: 'easeOutCirc'
    duration: 1000

  enhancePage: ->
    $(document).keyup @escapePressed
    @element.on 'click', '[data-dismiss="sideshow"]', @hide

  isOpen: ->
    @element.is(':visible')

  escapePressed: (e) =>
    if (e.keyCode == 27)
      if @isOpen()
        e.preventDefault()
        e.stopPropagation()
        @hide()

  show: =>
    return this if @isOpen()

    @element.trigger('show')

    @backdrop ?= $('<div class="sideshow-backdrop hide">').appendTo($('body')).show('fade', @transitionOptions.duration)
    @element.show 'slide', @transitionOptions, @transitionOptions.duration, =>
      @element.trigger('shown')

    this

  hide: =>
    return this unless @isOpen()

    @element.trigger('hide')

    if @backdrop?
      @backdrop.hide 'fade', @transitionOptions.duration, =>
        @backdrop.remove()
        @backdrop = null

    @element.hide 'slide', @transitionOptions, @transitionOptions.duration, =>
      @element.trigger('hidden')

    this

