#!/usr/bin/env bash
set -e
if [[ "$(pwd)" == *"demos"* ]]; then
  cd ..
fi
python python/train.py
python python/optimize.py
python python/.py
python python/train.py
