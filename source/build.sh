#!/bin/bash

coffee -cj "../app/assets/javascripts/clockpunch.js" coffee/*.coffee
sass styles/tooltip.scss ../app/assets/stylesheets/clockpunch.css
