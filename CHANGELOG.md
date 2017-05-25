# Clockpunch Changelog

## Version 0.1.12 (May 25, 2017)

  * Include source mapping file for CSS

## Version 0.1.11 (May 19, 2017)

  * Allow leaving a field blank until the user has taken action. Use this by
    adding the `data-allow-init-blank` attribute to your `input`.

## Version 0.1.10 (May 10, 2017)

  * Allow setting the hidden field directly and have it update the display field
    with `$("[name=myfield]").val(45).trigger("change")`

## Version 0.1.9 (January 29, 2016)

  * Fix errors if `clockpunch` is applied to the same element multiple times

## Version 0.1.8 (September 24, 2015)

  * Support Rails 4

## Version 0.1.7 (August 1, 2013)

  * Specify format via data-format attribute
  * Long (e.g. "1 hour 30 minutes") output format

## Version 0.1.6 (July 12, 2013)

  * New h?m format
  * Ability to set default format across the board

## Version 0.1.5 (July 12, 2013)

  * Don't apply timeinput multiple times
  * Ability to pass 'hm' as a time format
  * Began refactoring to allow application-defined formats via strings and functions

## Version 0.1.4 (July 10, 2013)

  * Support input type="number"

## Version 0.1.3 (July 2, 2013)

  * Can replace <span> or other elements with the specified format
  * Allow format as an option
