class window.TimeParser
  constructor: ->
    console.debug "Created new"
  to_minutes: (string) ->
    # string.split(':')
    string

  from_minutes: (minutes) ->
    # Drop decimals
    minutes = Math.floor(minutes)
    # Return zero if the input is less than 0
    minutes = 0 if minutes < 0
    
    hours = Math.floor(minutes / 60.0)
    mins = minutes % 60
    "#{hours}:#{this.pad mins.toString()}"

  pad: (str, max=2) ->
    if str.length < max then this.pad("0" + str, max) else str
