#= require ../widgets/widget

class @Slides extends Widget
  bindDom: ->
    @roomId = @element.data('room')
    @eventUrl = "/view/#{@roomId}/events"

  enhancePage: ->
    @eventSource = new EventSource(@eventUrl)
    @hookEvents()

  publish: (event, data) ->
    $.post @eventUrl,
           event: event
           data: data

  hookEvents: ->
    wrapHook = (hook) ->
      (e) ->
        data = JSON.parse(e.data)
        console.log "Push Event: [#{e.type}]: ", data

        hook(data, e.type, e)

    for name, hook of this
      continue unless typeof(hook) is 'function'
      capture = name.match /^(\w+)Hook/
      continue unless capture?
      @eventSource.addEventListener capture[1], wrapHook(hook)

  refreshHook: ->
    window.location.reload(true)
