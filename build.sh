#!/bin/bash

coffee -cj "app/assets/javascripts/time-parsing.js" coffee/*.coffee
sass styles/tooltip.scss app/assets/stylesheets/tooltip.css
