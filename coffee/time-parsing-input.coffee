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