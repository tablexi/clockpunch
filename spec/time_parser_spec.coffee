describe 'TimeParser', ->
  describe 'from_minutes', ->
    it 'should do less than an hour', ->
      parser = new TimeParser()
      expect(parser.from_minutes(40)).toEqual "0:40"

    it 'should zero pad less than 10 minutes', ->
      parser = new TimeParser()
      expect(parser.from_minutes(7)).toEqual "0:07"

    it 'should handle more than an hour', ->
      parser = new TimeParser()
      expect(parser.from_minutes(90)).toEqual "1:30"

    it 'should zero page between an hour and an hour ten', ->
      parser = new TimeParser()
      expect(parser.from_minutes(124)).toEqual "2:04"

    it 'should handle zero', ->
      parser = new TimeParser()
      expect(parser.from_minutes(0)).toEqual "0:00"

    it 'should go to zero on negative numbers', ->
      parser = new TimeParser()
      expect(parser.from_minutes(-45)).toEqual "0:00"

    it 'should round on decimals', ->
      parser = new TimeParser()
      expect(parser.from_minutes(45.2)).toEqual "0:45"