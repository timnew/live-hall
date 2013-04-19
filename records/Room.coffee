RoomSchema = new Services.Repository.Schema
  name: String
  description: String
  slidesId: String
  authInfo: String
  authedSession: String

RoomSchema.methods.unlock = (callback) ->
  @authInfo = null
  @authedSession = null
  @save(callback)

Room = Services.Repository.model 'Room', RoomSchema

module.exports = Room