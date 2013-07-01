// Generated by CoffeeScript 1.4.0

/*
Clockpunch 1.1
https://github.com/tablexi/clockpunch
*/


(function() {
  var $, TimeParsingInput;

  TimeParsingInput = (function() {

    function TimeParsingInput(elem, format) {
      var self;
      if (format == null) {
        format = null;
      }
      self = this;
      this.$elem = $(elem);
      this.$elem.data('timeparser', this);
      this.parser = new TimeParser();
      this.create_hidden_field(format);
      this.$elem.change(function() {
        var $this, minutes;
        $this = $(this);
        minutes = self.parser.to_minutes($(this).val());
        $this.data('timeparser').$hidden_field.val(minutes).trigger('change');
        return $this.val(self.parser.from_minutes(minutes));
      });
      this.$elem.trigger('change');
      this.create_tooltip();
    }

    TimeParsingInput.prototype.create_hidden_field = function() {
      var field_name;
      field_name = this.$elem.attr('name');
      this.$hidden_field = $("<input type=\"hidden\" />").attr('name', field_name);
      this.$elem.after(this.$hidden_field);
      return this.$elem.attr('name', "" + field_name + "_display");
    };

    TimeParsingInput.prototype.create_tooltip = function() {
      var $wrapper;
      $wrapper = $('<div/>').css('position', 'relative').css('display', 'inline-block');
      this.$elem.wrap($wrapper);
      this.$tooltip = $('<span/>').addClass('clockpunch-tooltip').hide();
      this.$tooltip.text(this.$elem.val());
      this.$elem.after(this.$tooltip);
      this.$elem.data('tooltip', this.$tooltip);
      this.$elem.bind('keyup', function() {
        var val;
        val = $(this).val() || 0;
        return $(this).data('tooltip').text(TimeParser.clean(val));
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

  if (typeof jQuery !== "undefined" && jQuery !== null) {
    $ = jQuery;
    $.fn.extend({
      timeinput: function(options) {
        return this.each(function(input_field) {
          return new TimeParsingInput(this);
        });
      }
    });
  }

  window.TimeParser = (function() {

    function TimeParser(time_format) {
      this.time_format = time_format != null ? time_format : "{HOURS}:{MINUTES}";
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

    TimeParser.clean = function(string) {
      var minutes;
      minutes = TimeParser.to_minutes(string);
      return TimeParser.from_minutes(minutes);
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
      return this.format(hours, mins);
    };

    TimeParser.prototype.format = function(hours, minutes) {
      return this.time_format.replace('{HOURS}', hours).replace('{MINUTES}', TimeParser.pad(minutes.toString()));
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

    return TimeParser;

  })();

}).call(this);