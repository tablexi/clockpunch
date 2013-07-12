describe 'TimeParser', ->
  beforeEach ->
    @parser = new TimeParser()

  describe 'from_minutes', ->
    describe 'default format', ->
      it 'should do less than an hour', ->
        expect(@parser.from_minutes(40)).toEqual "0:40"

      it 'should zero pad less than 10 minutes', ->
        expect(@parser.from_minutes(7)).toEqual "0:07"

      it 'should handle more than an hour', ->
        expect(@parser.from_minutes(90)).toEqual "1:30"

      it 'should zero pad between an hour and an hour ten', ->
        expect(@parser.from_minutes(124)).toEqual "2:04"

      it 'should handle zero', ->
        expect(@parser.from_minutes(0)).toEqual "0:00"

      it 'should go to zero on negative numbers', ->
        expect(@parser.from_minutes(-45)).toEqual "0:00"

      it 'should round on decimals', ->
        expect(@parser.from_minutes(45.2)).toEqual "0:45"

    describe 'hm format', ->
      beforeEach ->
        @parser = new TimeParser('hm')

      it 'should do less than an hour', ->
        expect(@parser.from_minutes(40)).toEqual "0h40m"

      it 'should zero pad less than 10 minutes', ->
        expect(@parser.from_minutes(7)).toEqual "0h07m"

      it 'should handle more than an hour', ->
        expect(@parser.from_minutes(90)).toEqual "1h30m"

      it 'should zero pad between an hour and an hour ten', ->
        expect(@parser.from_minutes(124)).toEqual "2h04m"

      it 'should handle zero', ->
        expect(@parser.from_minutes(0)).toEqual "0h00m"

    describe 'h?m format', ->
      beforeEach ->
        @parser = new TimeParser('h?m')

      it 'should not have hours for less than an hour', ->
        expect(@parser.from_minutes(40)).toEqual "40m"

      it 'should have the hours for more than an hour', ->
        expect(@parser.from_minutes(75)).toEqual "1h15m"

      it 'zero-pads minutes if more than an hour', ->
        expect(@parser.from_minutes(65)).toEqual "1h05m"

      it 'should not zero-pad the minutes', ->
        expect(@parser.from_minutes(5)).toEqual "5m"

    describe 'custom string format', ->
      beforeEach ->
        @parser = new TimeParser('r{HOURS}and{MINUTES}om')

      it 'should handle a number', ->
        expect(@parser.from_minutes(90)).toEqual "r1and30om"

    describe 'function format', ->
      beforeEach ->
        fn = (hours, minutes) ->
          total_minutes = hours * 60 + minutes
          "#{total_minutes}m"
        @parser = new TimeParser(fn)

      it 'should return the value described by the function', ->
        expect(@parser.from_minutes(90)).toEqual "90m"

  describe 'to_minutes', ->
    it 'should handle a number', ->
      expect(@parser.to_minutes(0)).toEqual 0

    it 'should handle a number', ->
      expect(@parser.to_minutes(30)).toEqual 30

    it 'should handle empty string', ->
      expect(@parser.to_minutes("")).toEqual 0

    describe 'just numbers', ->
      it 'should turn plain numbers into minutes', ->
        expect(@parser.to_minutes("12")).toEqual 12

    describe 'with decimals', ->
      it 'should turn .5 into half an hour', ->
        expect(@parser.to_minutes(".5")).toEqual 30
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

    describe 'with XhXXm syntax', ->
      it 'should handle a normal value', ->
        expect(@parser.to_minutes('1h15m')).toEqual 75

      it 'should handle just minutes', ->
        expect(@parser.to_minutes('15m')).toEqual 15

      it 'should handle just hours', ->
        expect(@parser.to_minutes('2h')).toEqual 120

      it 'should handle spaces', ->
        expect(@parser.to_minutes('2 h 10 m')).toEqual 130

      it 'handles large minutes', ->
        expect(@parser.to_minutes('85m')).toEqual 85

    describe 'bad inputs', ->
      it 'should discard letters', ->
        expect(@parser.to_minutes('abc')).toEqual 0

      it 'should discard letters, but leave the numbers', ->
        expect(@parser.to_minutes('ab2c')).toEqual 2

      it 'should discard letters and leave colons', ->
        expect(@parser.to_minutes('abc')).toEqual 0

      it 'should discard letters and leave colons', ->
        expect(@parser.to_minutes('a2b:c12')).toEqual 132

      it 'should discard letters and leave decimals', ->
        expect(@parser.to_minutes('2asdf.a5ad')).toEqual 150

  describe 'setting default format', ->
    it 'uses the new format for new parsers', ->
      TimeParser.set_default_format 'hm'
      parser = new TimeParser()
      expect(parser.from_minutes(30)).toEqual('0h30m')