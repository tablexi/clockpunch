#!/bin/bash

coffee --compile --output bin coffee
sass styles/tooltip.scss bin/tooltip.css
