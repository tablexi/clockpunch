#!/bin/bash

coffee --compile --output bin coffee
coffee --compile --output spec/bin spec
open spec/SpecRunner.html
