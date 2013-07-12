class window.TimeParser
  constructor: (time_format = null) ->
    @time_format = @get_format_mapping(time_format)

  ###
  # Class Methods
  ###

  @set_default_format: (string) ->
    @default_format = string

  @to_minutes: (string) ->
    parser = new TimeParser()
    parser.to_minutes(string)

  @from_minutes: (minutes) ->
    parser = new TimeParser()
    parser.from_minutes(minutes)

  @pad: (str, max=2) ->
    if str.length < max then this.pad("0" + str, max) else str

  ###
  # Instance methods
  ###

  # Convert a string value into minutes
  # 1.5 (i.e. hour and a half) => 90 minutes
  # 1:15 (one hour fifteen minutes) => 75 minutes
  # 0:15 or :15 => 15
  # 1h15m => 75 minutes
  to_minutes: (string) ->
    result = @read_format /(\d+)h(?:(\d{1,2})m)?/, string, (str) ->
      str.replace(/\s/g, '')

    result = @read_default string unless result

    result ||= { hours: 0, minutes: 0 }
    Math.ceil(result['hours'] * 60 + result['minutes'])

  # Render minutes as H:MM
  from_minutes: (minutes) ->
    # Drop decimals
    minutes = Math.floor(minutes)
    # Return zero if the input is less than 0
    minutes = 0 if minutes < 0

    hours = Math.floor(minutes / 60.0)
    mins = minutes % 60

    @time_format(hours, mins)

  transform: (string) ->
    @from_minutes @to_minutes(string)


  ###
  # PRIVATE
  ###

  # Read a number from a regular expression. Expects the regex to have
  # two matching groups: the first one being hours, the second one being minutes
  read_format: (regex, string, clean_function = null) ->
    cleaned_string = string.toString()
    cleaned_string = clean_function(cleaned_string) if clean_function?
    matches = cleaned_string.match regex
    return unless matches
    { hours: parseInt(matches[1]), minutes: parseInt(matches[2]) || 0}

  # default format of HH:MM
  read_default: (string) ->
    string = string.toString().replace /[^\d\:\.]/g, ''

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

    { hours: hours, minutes: minutes }


  # If it's a function, return the function

  get_format_mapping: (format) ->
    # return the function if the argument is a function
    return format if typeof format == 'function'

    formats = {
      default: (hours, minutes) ->
        @default_string_format('{HOURS}:{MINUTES}', hours, minutes)
      hm: (hours, minutes) ->
        @default_string_format('{HOURS}h{MINUTES}m', hours, minutes)
      "h?m": (hours, minutes) ->
        if hours > 0 then formats['hm'].call(@, hours, minutes) else "#{minutes}m"
      minutes: (hours, minutes) ->
        total_minutes = hours * 60 + minutes
        total_minutes.toString()
    }
    # return the default if format is null
    return formats[TimeParser.default_format || 'default'] unless format?

    # If the key matches a format, return that. Otherwise use it as a normal string format
    formats[format] || (hours, minutes) ->
      @default_string_format(format, hours, minutes)


  default_string_format: (format_string, hours, minutes) ->
    format_string.replace('{HOURS}', hours).replace('{MINUTES}', TimeParser.pad(minutes.toString()))

