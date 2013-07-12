// Generated by CoffeeScript 1.4.0

/*
Clockpunch 0.1.5
https://github.com/tablexi/clockpunch
*/


(function() {
  var $, TimeParsingInput;

  if (typeof jQuery !== "undefined" && jQuery !== null) {
    $ = jQuery;
    $.fn.extend({
      timeinput: function(options) {
        if (options == null) {
          options = {};
        }
        return this.each(function(input_field) {
          return new TimeParsingInput(this, options['format']);
        });
      }
    });
  }

  TimeParsingInput = (function() {

    function TimeParsingInput(elem, format) {
      if (format == null) {
        format = 'default';
      }
      this.$elem = $(elem);
      this.$elem.data('timeparser', this);
      this.parser = new TimeParser(format);
      if (this.$elem.is('input')) {
        this.configure_input();
      } else {
        this.configure_span(format);
      }
    }

    TimeParsingInput.prototype.configure_span = function(format) {
      var text;
      text = this.$elem.text();
      if (text.replace(/\s/g, '') === '') {
        return;
      }
      return this.$elem.text(this.parser.transform(text));
    };

    TimeParsingInput.prototype.configure_input = function(format) {
      var self;
      self = this;
      if (this.$elem.hasClass('clockpunch-applied')) {
        return;
      }
      this.create_hidden_field(format);
      this.ensure_elem_is_text();
      this.$elem.change(function() {
        var $this, minutes;
        $this = $(this);
        minutes = self.parser.to_minutes($(this).val());
        $this.data('timeparser').$hidden_field.val(minutes).trigger('change');
        return $this.val(self.parser.from_minutes(minutes));
      });
      this.$elem.trigger('change');
      this.create_tooltip();
      return this.$elem.addClass('clockpunch-applied');
    };

    TimeParsingInput.prototype.create_hidden_field = function() {
      var field_name;
      field_name = this.$elem.attr('name');
      this.$hidden_field = $("<input type=\"hidden\" />").attr('name', field_name);
      this.$elem.after(this.$hidden_field);
      return this.$elem.attr('name', "" + field_name + "_display");
    };

    TimeParsingInput.prototype.ensure_elem_is_text = function() {
      var new_elem;
      if (this.$elem.is('[type=text]')) {
        return;
      }
      new_elem = this.$elem.clone(true);
      new_elem.attr('type', 'text');
      this.$elem.replaceWith(new_elem);
      return this.$elem = new_elem;
    };

    TimeParsingInput.prototype.create_tooltip = function() {
      var $wrapper, self;
      self = this;
      $wrapper = $('<div/>').css('position', 'relative').css('display', 'inline-block');
      this.$elem.wrap($wrapper);
      this.$tooltip = $('<span/>').addClass('clockpunch-tooltip').hide();
      this.$tooltip.text(this.$elem.val());
      this.$elem.after(this.$tooltip);
      this.$elem.data('tooltip', this.$tooltip);
      this.$elem.bind('keyup', function() {
        var val;
        val = $(this).val() || 0;
        return $(this).data('tooltip').text(self.parser.transform(val));
      });
      this.$elem.bind('focus', function() {
        return $(this).data('tooltip').fadeIn('fast');
      });
      return this.$elem.bind('blur', function() {
        return $(this).data('tooltip').fadeOut('fast');
      });
    };

    return TimeParsingInput;

  })();

  window.TimeParser = (function() {

    function TimeParser(time_format) {
      if (time_format == null) {
        time_format = null;
      }
      this.time_format = this.get_format_mapping(time_format);
    }

    /*
      # Class Methods
    */


    TimeParser.to_minutes = function(string) {
      var parser;
      parser = new TimeParser();
      return parser.to_minutes(string);
    };

    TimeParser.from_minutes = function(minutes) {
      var parser;
      parser = new TimeParser();
      return parser.from_minutes(minutes);
    };

    TimeParser.pad = function(str, max) {
      if (max == null) {
        max = 2;
      }
      if (str.length < max) {
        return this.pad("0" + str, max);
      } else {
        return str;
      }
    };

    /*
      # Instance methods
    */


    TimeParser.prototype.to_minutes = function(string) {
      var result;
      result = this.read_format(/(\d+)h(?:(\d{1,2})m)?/, string, function(str) {
        return str.replace(/\s/g, '');
      });
      if (!result) {
        result = this.read_default(string);
      }
      result || (result = {
        hours: 0,
        minutes: 0
      });
      return Math.ceil(result['hours'] * 60 + result['minutes']);
    };

    TimeParser.prototype.from_minutes = function(minutes) {
      var hours, mins;
      minutes = Math.floor(minutes);
      if (minutes < 0) {
        minutes = 0;
      }
      hours = Math.floor(minutes / 60.0);
      mins = minutes % 60;
      return this.time_format(hours, mins);
    };

    TimeParser.prototype.transform = function(string) {
      return this.from_minutes(this.to_minutes(string));
    };

    /*
      # PRIVATE
    */


    TimeParser.prototype.read_format = function(regex, string, clean_function) {
      var cleaned_string, matches;
      if (clean_function == null) {
        clean_function = null;
      }
      cleaned_string = string.toString();
      if (clean_function != null) {
        cleaned_string = clean_function(cleaned_string);
      }
      matches = cleaned_string.match(regex);
      if (!matches) {
        return;
      }
      return {
        hours: parseInt(matches[1]),
        minutes: parseInt(matches[2]) || 0
      };
    };

    TimeParser.prototype.read_default = function(string) {
      var hours, minutes, parts;
      string = string.toString().replace(/[^\d\:\.]/g, '');
      if (string === '') {
        return 0;
      }
      if (string.indexOf(":") >= 0) {
        parts = string.split(':');
        hours = parseFloat(parts[0] || 0);
        minutes = Math.floor(parseFloat(parts[1] || 0));
      } else if (string.indexOf(".") >= 0) {
        hours = parseFloat(string);
        minutes = 0;
      } else {
        hours = 0;
        minutes = parseFloat(string);
      }
      return {
        hours: hours,
        minutes: minutes
      };
    };

    TimeParser.prototype.get_format_mapping = function(format) {
      var formats;
      if (typeof format === 'function') {
        return format;
      }
      formats = {
        "default": function(hours, minutes) {
          return this.default_string_format('{HOURS}:{MINUTES}', hours, minutes);
        },
        hm: function(hours, minutes) {
          return this.default_string_format('{HOURS}h{MINUTES}m', hours, minutes);
        },
        minutes: function(hours, minutes) {
          var total_minutes;
          total_minutes = hours * 60 + minutes;
          return total_minutes.toString();
        }
      };
      if (format == null) {
        return formats['default'];
      }
      return formats[format] || function(hours, minutes) {
        return this.default_string_format(format, hours, minutes);
      };
    };

    TimeParser.prototype.default_string_format = function(format_string, hours, minutes) {
      return format_string.replace('{HOURS}', hours).replace('{MINUTES}', TimeParser.pad(minutes.toString()));
    };

    return TimeParser;

  })();

}).call(this);
