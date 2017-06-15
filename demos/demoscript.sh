#!/usr/bin/env bash
set -e
if [[ "$(pwd)" == *"demos"* ]]; then
  cd ..
fi

echo 'TRAINING...'
python python/train.py

echo 'OPTIMIZING...'
python python/optimize.py

echo 'FINE TUNING...'
python python/tune.py

echo 'TESTING...'
python python/predict.py data/test 2 # predict 2 images in data/test

echo 'PREDICTING...'
python python/predict.py data/hand 17 # predict 17 images in data/hand
