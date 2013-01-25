class window.TimeParser
  # Convert a string value into minutes
  # 1.5 (i.e. hour and a half) => 90 minutes
  # 1:15 (one hour fifteen minutes) => 75 minutes
  # 0:15 or :15 => 15
  to_minutes: (string) ->
    string = string.replace /[^\d\:\.]/g, ''
    
    return 0 if string == ''

    if string.indexOf(":") >= 0
      parts = string.split ':'
      
      hours = parseFloat(parts[0] || 0)
      # Drop anything after a decimal in minutes
      minutes = Math.floor(parseFloat(parts[1] || 0))
    else if string.indexOf(".") >= 0
      hours = parseFloat(string)
      minutes = 0
    else
      hours = 0
      minutes = parseFloat(string)

    Math.ceil(hours * 60 + minutes)

  # Render minutes as H:MM
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
