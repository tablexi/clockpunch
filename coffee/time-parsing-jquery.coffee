$ = jQuery

$.fn.extend({
  timeinput: (options) ->
    this.each (input_field) ->
      new TimeParsingInput(this)
})

class TimeParsingInput
  constructor: (elem) ->
    @$elem = $ elem
    @parser = new TimeParser()
    @$elem.data('time_parser', @parser)
    
    @create_hidden_field

    @$elem.change ->
      $this = $ this
      parser = $this.data('time_parser')
      minutes = parser.to_minutes($(this).val())
      $this.next('input').val(minutes)
      $this.val(parser.from_minutes(minutes))

    @$elem.trigger('change')
  
  create_hidden_field: ->
    field_name = @$elem.attr('name')
    $new_field = $("<input type=\"hidden\" />").attr('name', field_name)
    @$elem.after $new_field
    @$elem.attr('name', "#{field_name}_display")
