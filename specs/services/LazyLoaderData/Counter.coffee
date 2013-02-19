exports = module.exports =
  counters: {}
  get: (name) ->
    @counters[name] ? 0
  increase: (name) ->
    @counters[name] = @get(name) + 1
