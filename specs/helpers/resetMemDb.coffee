Services.Repository.resetMemDb = ->
  adapter = Services.Repository.adapter
  adapter.cache[key] = {} for key of adapter.cache
  adapter.ids[key] = 1 for key of adapter.ids
