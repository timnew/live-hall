RoomSchema = new Services.Repository.Schema
  name: String
  description: String
  slidesId: String
  locker: String

Room = Services.Repository.model 'Room', RoomSchema

module.exports = Room