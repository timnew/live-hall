# Smoke Test for test environment configuration, fails when environment is not correctly configured

describe 'environment', ->
  it 'chai', ->
    true.should.be.ok

  it 'coffee-script', ->
    require.extensions['.coffee'].should.be.ok

  it 'createLazyLoader', ->
    createLazyLoader.should.be.instanceOf Function

  it 'createPathHelper', ->
    createPathHelper.should.be.instanceOf Function

  it 'rootPath', ->
    rootPath.should.be.instanceOf Function
    rootPath.specs().should.equal __dirname

  it 'Services', ->
    Services.should.be.instanceOf Object

  it 'configuration', ->
    configuration.apiServer.should.be.ok