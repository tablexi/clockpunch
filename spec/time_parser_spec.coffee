describe 'TimeParser', ->
  describe 'from_minutes', ->
    beforeEach ->
      @parser = new TimeParser()

    it 'should do less than an hour', ->      
      expect(@parser.from_minutes(40)).toEqual "0:40"

    it 'should zero pad less than 10 minutes', ->
      expect(@parser.from_minutes(7)).toEqual "0:07"

    it 'should handle more than an hour', ->
      expect(@parser.from_minutes(90)).toEqual "1:30"

    it 'should zero page between an hour and an hour ten', ->
      expect(@parser.from_minutes(124)).toEqual "2:04"

    it 'should handle zero', ->
      expect(@parser.from_minutes(0)).toEqual "0:00"

    it 'should go to zero on negative numbers', ->
      expect(@parser.from_minutes(-45)).toEqual "0:00"

    it 'should round on decimals', ->
      expect(@parser.from_minutes(45.2)).toEqual "0:45"