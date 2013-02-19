repository = Services.ExpirableRepository

describe 'Expirable Repository', ->
  key = 'key'

  it 'write and read string value', (done) ->
    value = 'value'
    repository.setValue key, value, (err) ->
      return done(err) if err?

      repository.getValue key, (err, actualValue) ->
        return done(err) if err?

        actualValue.should.equal value
        done()

  it 'write and read primitive value', (done) ->
    value = 123.5
    repository.setValue key, value, (err) ->
      return done(err) if err?

      repository.getValue key, (err, actualValue) ->
        return done(err) if err?

        actualValue.should.equal value
        done()

  it 'write and read object value', (done) ->
    value =
      a: 1
      b: 'xxxx'
      c: null
      d:
        e: true
        f: false

    repository.setValue key, value, (err) ->
      return done(err) if err?

      repository.getValue key, (err, actualValue) ->
        return done(err) if err?

        actualValue.should.eql value
        done()

  it 'should remove value after it expires', (done) ->
    value = 'value'

    repository.setValue key, value, 1000, (err) ->
      return done(err) if err?

      values = []
      index = 0

      readValue = ->
        repository.getValue key, (err, actualValue) ->
          if err?
            values[index] = err
          else
            values[index] = actualValue

          index++

      verify = ->
        values.should.eql ['value', undefined]
        done()

      setTimeout readValue, 995

      setTimeout readValue, 1005

      setTimeout verify, 1010

  after ->
    repository.deleteValue key
