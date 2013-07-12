# Time Parsing

This library comprises the following pieces:

1. Functions for parsing hour:minute strings and outputing minutes, and vice versa
2. A jQuery plugin that binds to an input's change event to automatically update it to the H:MM format and store the integer minute value in a hidden field.
3. A gem that you can use with Rails to include the library through the asset pipeline

## Parsing

    var parser = new TimeParser()
    parser.to_minutes("1:27") // returns 87

### Examples and rules
<table>
  <tr>
    <th>Input</th>
    <th></th>
    <th>Output in minutes</th>
  <tr>
    <td>1:00</td>
    <td>1 hour</td>
    <td>60
  </tr>
  <tr>
    <td>0:45</td>
    <td>Forty-five minutes</td>
    <td>45</td>
  </tr>
  <tr>
    <td>:45</td>
    <td>Forty-five minutes</td>
    <td>45</td>
  </tr>
  <tr>
    <td>45</td>
    <td>Forty-five minutes</td>
    <td>45</td>
  </tr>
  <tr>
    <td>1.5</td>
    <td>One and a half hours</td>
    <td>90</td>
  </tr>
  <tr>
    <td>.5</td>
    <td>Half an hour</td>
    <td>30</td>
  </tr>
  <tr>
    <td>1h30m</td>
    <td>1 hour, 30 minutes</td>
    <td>90</td>
  </tr>
  <tr>
    <td>1h</td>
    <td>1 hour</td>
    <td>60</td>
  </tr>
  <tr>
    <td>20m</td>
    <td>20 minutes</td>
    <td>20</td>
  </tr>
</table>

### Bad input

- Negative time is always converted to zero. E.g. "-45" becomes 0 minutes
- All characters besides numbers, decimals, and colons are stripped before any parsing. This means something like "#4ba.2" becomes "4.2", which is 252 minutes.
- If there are multiple colons, everything after the second one is dropped. E.g. "2:30:15" is treated like "2:30"
- If you have both colons and decimals, the string is split first on the colon. Hours are read as a decimal, minutes are rounded down.
   - "1.2:30" is read as 1.2 hours, 30 minutes, coming out as 72.
   - "1:30.2" is read like "1:30"
- See spec/time_parser_spec.coffee for more examples of how input is handled.

### Formats

#### Built-in formats:

  * default: "H:MM"
    * Zero-padded minutes
  * hm: "HmMMm"
    * Zero-padded minutes
  * minutes: MMm
    * Not zero-padded. Always show total minutes. E.g. 90 minutes stays "90m"
  * h?m
    * If more than an hour it's the same as 'hm'
    * Does not zero-pad minutes if less than an hour

To use one of the other formats, just pass it in the constructor, e.g. `new TimeParser('hm')`

#### Custom formats

You can also pass custom formats either as a string or a function. This feature is still in development.

# Use in Forms

Apply the jQuery plugin to the elements:

    $('.timeinput').timeinput();

# Rails

## Installation

Add this line to your application's Gemfile:

    gem "clockpunch"

## Include the assets
Add to your `application.js`

    //= require clockpunch

Add to your `application.scss`

    //= require clockpunch

# Standalone

Copy `app/assets/javascripts/clockpunch.js` and `app/assets/stylesheets/clockpunch.css` into your
application and include them using `<script src="clockpunch.js"></script>` and `<style>@import url(clockpunch.css)</style>`

# Building

From the `/source` directory, run `./build.sh`. This will generate the files in `app/assets`.

TODO: node, npm installation of coffeescript, sass installation
