request = require('../../services/PlayUpRequest')

###
 GET /external/users/search?token=t4rF3hQUDSiMQFA3zanAfS8eJsvRLF7wTWthq0hpFEC3XpSW8fZBUqLlMrKFcbjs HTTP/1.1
 X-Playup-Api-Key: com.playup.ios.live 52rJdo2FZeUTRdl7AAs6uf0ZBIwmuF454S72YwOxSMfJyJ2o0LR/GjoH6k46jZ8U
 Authorization: MAC id="841Rt1fZsYvdpfm5GjuUGZ4K3eqizYn8",ts="1356580385",nonce="UjeWZ6hlJjBCk9TxBrezBbIxMzU2NTgwMzg1",mac="Lb6qsRcy1MTsxEuFeLV5WlTjJ5cifNnWGEI3DOLafc8="
 Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3
 Accept: * /*
 User-Agent: Ruby
 Connection: close
 Host: localhost:8080
 ###

describe "Fetch User Info", ->
  it 'should succeeded', (done) ->
    request.get("http://localhost:8080/external/users/search")
      .query
        token: 't4rF3hQUDSiMQFA3zanAfS8eJsvRLF7wTWthq0hpFEC3XpSW8fZBUqLlMrKFcbjs'
      .playUpApiKey()
      .authHmac(configuration.apiServer)
      .endWithModel (res, model) ->
        res.status.should.equal 200
        model.should.have.property ':type', 'application/vnd.playup.external.user+json'
        done()
