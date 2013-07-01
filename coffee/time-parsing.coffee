# We're only going to include this section if jQuery is defined
if jQuery?
  $ = jQuery

  $.fn.extend({
    timeinput: (options) ->
      this.each (input_field) ->
        new TimeParsingInput(this)
  })

class window.TimeParser
  constructor: (@time_format = "{HOURS}:{MINUTES}") ->

  ###
  # Class Methods
  ###

  @to_minutes: (string) ->
    parser = new TimeParser()
    parser.to_minutes(string)

  @from_minutes: (minutes) ->
    parser = new TimeParser()
    parser.from_minutes(minutes)

  @clean: (string) ->
    minutes = TimeParser.to_minutes string
    TimeParser.from_minutes minutes

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
    @format(hours, mins)

  format: (hours, minutes) ->
    @time_format.replace('{HOURS}', hours).replace('{MINUTES}', TimeParser.pad(minutes.toString()))


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

class TimeParsingInput

  constructor: (elem, format = null) ->
    self = this
    @$elem = $ elem

    @$elem.data('timeparser', this)
    @parser = new TimeParser()

    @create_hidden_field(format)

    @$elem.change ->
      $this = $ this
      # Set the value of the hidden field to this value in minutes
      minutes = self.parser.to_minutes($(this).val())
      $this.data('timeparser').$hidden_field.val(minutes)
                                            .trigger('change')

      # Replace this value with H:MM format
      $this.val(self.parser.from_minutes(minutes))

    # Make sure that we're up to date
    @$elem.trigger('change')

    @create_tooltip()

  create_hidden_field: ->
    field_name = @$elem.attr('name')
    @$hidden_field = $("<input type=\"hidden\" />").attr('name', field_name)
    @$elem.after @$hidden_field
    @$elem.attr('name', "#{field_name}_display")

  create_tooltip: ->
    # Wrap in a relative position element so we can
    # position the tooltip accurately
    $wrapper = $('<div/>').css('position', 'relative')
                          .css('display', 'inline-block')
    @$elem.wrap $wrapper

    # Build the tooltip
    @$tooltip = $('<span/>').addClass('tooltip').hide()
    @$tooltip.text @$elem.val()
    @$elem.after @$tooltip

    # Store the tooltip as a data attribute on the element so we
    # can access it easily
    @$elem.data('tooltip', @$tooltip)

    @$elem.bind 'keyup', ->
      val = $(this).val() || 0
      $(this).data('tooltip').text TimeParser.clean(val)

    @$elem.bind 'focus', ->
      $(this).data('tooltip').fadeIn('fast')

    @$elem.bind 'blur', ->
      $(this).data('tooltip').fadeOut('fast')

