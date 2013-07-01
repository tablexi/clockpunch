#!/bin/bash

./build.sh
coffee --compile --output spec/bin spec
open spec/SpecRunner.html
