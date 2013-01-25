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

class TimeParsingInput
  @parser = new TimeParser()

  constructor: (elem) ->
    @$elem = $ elem
    
    @create_hidden_field

    @$elem.change ->
      $this = $ this
      # Set the value of the hidden field to this value in minutes
      minutes = TimeParsingInput.parser.to_minutes($(this).val())
      $this.next('input').val(minutes)
      # Replace this value with H:MM format
      $this.val(TimeParsingInput.parser.from_minutes(minutes))

    @$elem.trigger('change')
  
  create_hidden_field: ->
    field_name = @$elem.attr('name')
    $new_field = $("<input type=\"hidden\" />").attr('name', field_name)
    @$elem.after $new_field
    @$elem.attr('name', "#{field_name}_display")

