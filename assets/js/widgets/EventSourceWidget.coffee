#= require ./widget

wrapHook = (hook) ->
  (e) ->
    data = JSON.parse(e.data)
    console.log "Recieved Event: [#{e.type}]: ", data
    hook(data, e.type, e)

class @EventSourceWidget extends Widget
  publishEvent: (event, data) ->
    console.log "Publish Event: [#{event}]: ", data
    $.post @eventUrl,
           event: event
           data: data

  initEventSource: (url) ->
    @eventSource = new EventSource(url)

  hookEvent: (event, hook) ->
    @eventSource.addEventListener event, wrapHook(hook)

  hookEvents: (host = this) ->
    for name, hook of host
      continue unless typeof(hook) is 'function'
      capture = name.match /^(\w+)Hook/
      continue unless capture?
      @eventSource.addEventListener capture[1], wrapHook(hook)
