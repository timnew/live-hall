#= require ../widgets/widget

class SlidesWidget extends Widget
  bindDom: ->
    @locateSlidesWidget()

  locateSlidesWidget: ->
    @slides = @findParentWidgetByType('SlidesViewer')
    return @isPresenter = false if @slides?

    @slides = @findParentWidgetByType('SlidesPresenter')
    return @isPresenter = true if @slides?

    throw 'Cannnot found Slides Widget'

class @YoutubeVideoPlayer extends SlidesWidget
  bindDom: ->
    super()
    @id = @element.attr('id')
    @messageId = "videoStatusChanged#{@id}"

  enhancePage: ->
    $(document).on 'YT.ApiReady', =>
      @player = new YT.Player @id,
                            events:
                              'onStateChange': @playerStateChanged

    @slides.hookEvent @messageId, @videoStatusChangedHook

  playerStateChanged: (e) =>
    if @isPresenter
      switch e.data
        when YT.PlayerState.PLAYING
          @slides.publish @messageId,
                                   status: e.data

        when YT.PlayerState.PAUSED
          @slides.publish @messageId,
                                   status: e.data

  videoStatusChangedHook: (state) =>
    state.status = parseInt(state.status, 10)
    switch state.status
      when YT.PlayerState.PLAYING

        @player.playVideo()

      when YT.PlayerState.PAUSED
        @player.pauseVideo()

Widget.onActivated ->
  window.onYouTubeIframeAPIReady = ->
    $(document).trigger('YT.ApiReady')

  $('<script src="//www.youtube.com/iframe_api">').prependTo document

