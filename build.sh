#!/bin/bash

coffee -cj "bin/time-parsing.js" coffee/*.coffee
sass styles/tooltip.scss bin/tooltip.css
