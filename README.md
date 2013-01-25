# Time Parsing

This library consists of two parts:

1. Functions for parsing hour:minute strings and outputing minutes, and vice versa
2. A jQuery plugin that binds to an input's change event to automatically update it to the H:MM format and store the integer minute value in a hidden field.

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
</table>

### Bad input

- Negative time is always converted to zero. E.g. "-45" becomes 0 minutes
- All characters besides numbers, decimals, and colons are stripped before any parsing. This means something like "#4ba.2" becomes "4.2", which is 252 minutes.
- If there are multiple colons, everything after the second one is dropped. E.g. "2:30:15" is treated like "2:30"
- If you have both colons and decimals, the string is split first on the colon. Hours are read as a decimal, minutes are rounded down.
   - "1.2:30" is read as 1.2 hours, 30 minutes, coming out as 72.
   - "1:30.2" is read like "1:30"
- See spec/time_parser_spec.coffee for more examples of how input is handled.


