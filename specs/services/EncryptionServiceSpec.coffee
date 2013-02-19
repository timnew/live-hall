describe "EncryptionService", ->
  service = require(rootPath.services('EncryptionService'))

  describe 'aes', ->
    it 'should encrypt and decrypt object with default private key', ->
      originalObj =
        a: 'b'
        b: 123
        c:
          e: 'embeded'
          f: 232.22222

      encryptedObj = service.encryptObj(originalObj)
      encryptedObj.should.not.eql originalObj

      decryptedObj = service.decryptObj(encryptedObj)
      decryptedObj.should.eql originalObj

    it 'should encrypt and decrypt with given key', ->
      originalObj =
        a: 'b'
        b: 123
        c:
          e: 'embeded'
          f: 232.22222

      key = 'p@ssw0rd'

      encryptedObj = service.encryptObj(originalObj, key)

      encryptedObj.should.not.eql originalObj
      encryptedObj.should.not.eql service.encryptObj(originalObj)

      decryptedObj = service.decryptObj(encryptedObj, key)
      decryptedObj.should.eql originalObj

    xit "test", ->
      a = service.encryptObj {
        "product_id": "864EA371-E9BA-4F34-9118-8547FD493871",
        "store-product": [
          {
          "vendor": "appstore"
          "product": "com.playup.content.pricing.tier2"
          },
          {
          "vendor": "googleplay"
          "product": "com.playup.content.pricing.tier2"
          }
        ],
        "expiration": "2013-12-31 15:01:00+00",
        "source-options": [
          {
          ":href": "http://sample-prover.playupdev.com/video/432",
          "type": "video/3gp"
          },
          {
          ":href": "http://sample-prover.playupdev.com/video/432",
          "type": "video/mp4"
          }
        ],
        "issue-to": {
        ":type": "application/vnd.playup.ticketing.user+json",
        #    "uuid": "t4rF3hQUDSiMQFA3zanAfS8eJsvRLF7wTWthq0hpFEC3XpSW8fZBUqLlMrKFcbjs"
        "uuid": "6iEXSk24hWTTg3XL4XQc121J49R4Ip0+eCbEDiegnS7BQ1KZdEcAkltpSPoihYl7D/4jxOe+5AIUejes3pXUGg=="
        }
      }

      console.log a

  describe 'rsa', ->
    it 'should encrypt and decrypt object with RSA', ->
      original = 'embeded'

      encrypted = service.rsaEncrypt(original)

      encrypted.should.not.eql original

      decrypted = service.rsaDecrypt(encrypted)
      decrypted.should.eql original

    it 'should process when data is larger than 256 bytes', ->
      original = [1..256].join(',')

      encrypted = service.rsaEncrypt(original)

      encrypted.should.not.eql original

      decrypted = service.rsaDecrypt(encrypted)
      decrypted.should.eql original

