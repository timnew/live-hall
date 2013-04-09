RoomSchema = new Services.Repository.Schema
  name: String
  description: String
  slidesId: String

Room = Services.Repository.model 'Room', RoomSchema

module.exports = Room