$ = jQuery

$.fn.extend({
  timeinput: (options) ->
    this.each((input_field) ->
      $this = $ this
      $this.change ->
        parser = new TimeParser()
        minutes = parser.to_minutes($(this).val())
        $('#output').text(parser.from_minutes minutes)
    )
})