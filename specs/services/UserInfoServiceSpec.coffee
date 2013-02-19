expect = require('chai').expect
sinon = require('sinon')

describe "UserInfoService", ->
  service = require(rootPath.services('UserInfoService'))

  beforeEach ->
    Services.Repository.resetMemDb()

  it 'should export service', ->
    service.should.be.ok

  describe 'Get user info', ->
    it 'should return user info', (done) ->
      service.getUserInfo '6iEXSk24hWTTg3XL4XQc121J49R4Ip0+eCbEDiegnS7BQ1KZdEcAkltpSPoihYl7D/4jxOe+5AIUejes3pXUGg==', (err, userInfo) ->
        userInfo.uuid.should.equal 't4rF3hQUDSiMQFA3zanAfS8eJsvRLF7wTWthq0hpFEC3XpSW8fZBUqLlMrKFcbjs'
        done()

    it 'should return null if user is not valid', (done) ->
      service.getUserInfo 't4rF3hQUDSiMQFA3zanAfS8eJsvRLF7wTWthq0hpFEC3XpSW8fZBUqLlMrKF%0Acbjs%0A', (err, userInfo) ->
        expect(userInfo).to.not.be.ok
        done()

  describe "Get user uuid", ->
    it 'should return user uuid', (done) ->
      service.getUserUuid '6iEXSk24hWTTg3XL4XQc121J49R4Ip0+eCbEDiegnS7BQ1KZdEcAkltpSPoihYl7D/4jxOe+5AIUejes3pXUGg==', (err, uuid) ->
        uuid.should.equal 't4rF3hQUDSiMQFA3zanAfS8eJsvRLF7wTWthq0hpFEC3XpSW8fZBUqLlMrKFcbjs'
        done()

    it 'should return null if user is not valid', (done) ->
      service.getUserUuid 't4rF3hQUDSiMQFA3zanAfS8eJsvRLF7wTWthq0hpFEC3XpSW8fZBUqLlMrKF%0Acbjs%0A', (err, uuid) ->
        expect(uuid).to.not.be.ok
        done()


  describe "User info cache", ->
    spy = null

    before ->
      spy = sinon.spy(Services.PlayUpRequest, 'get')

    after ->
      spy.restore()

    it 'should not fire query to api with old token', (done) ->
      service.getUserInfo '6iEXSk24hWTTg3XL4XQc121J49R4Ip0+eCbEDiegnS7BQ1KZdEcAkltpSPoihYl7D/4jxOe+5AIUejes3pXUGg==', (err, userInfo) ->
        userInfo.uuid.should.equal 't4rF3hQUDSiMQFA3zanAfS8eJsvRLF7wTWthq0hpFEC3XpSW8fZBUqLlMrKFcbjs'
        spy.calledOnce.should.be.true

        service.getUserInfo '6iEXSk24hWTTg3XL4XQc121J49R4Ip0+eCbEDiegnS7BQ1KZdEcAkltpSPoihYl7D/4jxOe+5AIUejes3pXUGg==', (err, userInfo) ->
          userInfo.uuid.should.equal 't4rF3hQUDSiMQFA3zanAfS8eJsvRLF7wTWthq0hpFEC3XpSW8fZBUqLlMrKFcbjs'
          spy.calledOnce.should.be.true

          done()


