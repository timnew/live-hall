path = require('path')
makePath = require('../../services/PathHelper.coffee')

describe "Expand Path", ->
  rootPath  = makePath path.join(__dirname, 'PathHelperData/something/..')

  it "should expand Path root path", ->
    rootPath().should.equal path.join(__dirname, 'PathHelperData')

  it "should expand file paths", ->
    rootPath('File').should.equal path.join(__dirname, 'PathHelperData', 'File')
    rootPath('file.ext').should.equal path.join(__dirname, 'PathHelperData', 'file.ext')

  it "should expand multiple path", ->
    rootPath('subdir', 'file').should.equal path.join(__dirname, 'PathHelperData', 'subdir', 'file')

  it "should consolidate dir path", ->
    consolidateReturns = rootPath.consolidate()
    consolidateReturns.should.equal rootPath
    rootPath.subdir().should.equal path.join(__dirname, 'PathHelperData', 'subdir')
    rootPath.subdir('file').should.equal path.join(__dirname, 'PathHelperData', 'subdir', 'file')


