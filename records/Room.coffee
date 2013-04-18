RoomSchema = new Services.Repository.Schema
  name: String
  description: String
  slidesId: String
  authInfo: String
  authedSession: String

Room = Services.Repository.model 'Room', RoomSchema

module.exports = Room