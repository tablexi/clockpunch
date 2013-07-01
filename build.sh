#!/bin/bash

coffee -cj "clockpunch/app/assets/javascripts/clockpunch.js" coffee/*.coffee
sass styles/tooltip.scss clockpunch/app/assets/stylesheets/clockpunch.css
