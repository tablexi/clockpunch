describe 'TimeParser', ->
  beforeEach ->
      @parser = new TimeParser()

  describe 'from_minutes', ->
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

  describe 'to_minutes', ->
    describe 'just numbers', ->
      it 'should turn plain numbers into hours', ->
        expect(@parser.to_minutes("12")).toEqual 720

    describe 'with decimals', ->
      it 'should turn 0.5 into half an hour', ->
        expect(@parser.to_minutes("0.5")).toEqual 30

      it 'should turn 1.5 into 90 minutes', ->
        expect(@parser.to_minutes("1.5")).toEqual 90

      it 'should turn 1.25 into hour fifteen', ->
        expect(@parser.to_minutes("1.25")).toEqual 75

      it 'should round 1.33 to 80 minutes', ->
        expect(@parser.to_minutes("1.33")).toEqual 80

      it 'should discard everything after a second decimal', ->
        expect(@parser.to_minutes('1.2.5')).toEqual 72

    describe 'with colons', ->
      it 'should handle a normal number', ->
        expect(@parser.to_minutes('1:15')).toEqual 75

      it 'should handle nothing in front of the colon', ->
        expect(@parser.to_minutes(':45')).toEqual 45

      # Correct behavior?
      it 'should turn 0:4 into four minutes', ->
        expect(@parser.to_minutes('0:4')).toEqual 4

      it 'should turn :4 into four minutes', ->
        expect(@parser.to_minutes(':4')).toEqual 4

      it 'should drop everything after the second colon', ->
        expect(@parser.to_minutes('1:12:32')).toEqual 72

      it 'should carry numbers over 60 in the minute position', ->
        expect(@parser.to_minutes('1:65')).toEqual 125

      describe 'and decimals', ->
        it 'should drop anything after the decimal if the colon comes first', ->
          expect(@parser.to_minutes('1:23.4')).toEqual 83

        # Correct behavior?
        it 'should convert an hour with decimal and add the minutes', ->
          expect(@parser.to_minutes('1.2:01')).toEqual 73

    describe 'bad inputs', ->
      it 'should discard letters', ->
        expect(@parser.to_minutes('abc')).toEqual 0

      it 'should discard letters, but leave the numbers', ->
        expect(@parser.to_minutes('ab2c')).toEqual 120

      it 'should discard letters and leave colons', ->
        expect(@parser.to_minutes('abc')).toEqual 0

      it 'should discard letters and leave colons', ->
        expect(@parser.to_minutes('a2b:c12')).toEqual 132

      it 'should discard letters and leave decimals', ->
        expect(@parser.to_minutes('2asdf.a5ad')).toEqual 150
