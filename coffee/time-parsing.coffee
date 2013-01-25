# We're only going to include this section if jQuery is defined
if jQuery?
  $ = jQuery

  $.fn.extend({
    timeinput: (options) ->
      this.each (input_field) ->
        new TimeParsingInput(this)
  })

class window.TimeParser
  # Convert a string value into minutes
  # 1.5 (i.e. hour and a half) => 90 minutes
  # 1:15 (one hour fifteen minutes) => 75 minutes
  # 0:15 or :15 => 15
  @to_minutes: (string) ->
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
  @from_minutes: (minutes) ->
    # Drop decimals
    minutes = Math.floor(minutes)
    # Return zero if the input is less than 0
    minutes = 0 if minutes < 0
    
    hours = Math.floor(minutes / 60.0)
    mins = minutes % 60
    "#{hours}:#{this.pad mins.toString()}"

  @clean: (string) ->
    minutes = TimeParser.to_minutes string
    TimeParser.from_minutes minutes

  @pad: (str, max=2) ->
    if str.length < max then this.pad("0" + str, max) else str

class TimeParsingInput

  constructor: (elem) ->
    @$elem = $ elem
    console.debug 'storing ad timeparser', this
    @$elem.data('timeparser', this)
    
    @create_hidden_field()

    @$elem.change ->
      $this = $ this
      # Set the value of the hidden field to this value in minutes
      minutes = TimeParser.to_minutes($(this).val())
      $this.data('timeparser').$hidden_field.val(minutes)
      
      # Replace this value with H:MM format
      $this.val(TimeParser.from_minutes(minutes))

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

