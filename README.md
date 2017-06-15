# clubbed

## Matlab

While this library is primarily written in Python, there are complement Matlab scripts used for scanning a hand and creating a three-dimensional mesh. It then takes 17 images of the hand; 1 image every 20 degrees about the y-axis. The recommended way of running this library would be the following inside the root Matlab directory:

```
user@/MATLAB$ git clone https://github.com/jamesalbert/clubbed.git
```

then in the **Matlab console**:

```
$ cd clubbed/demos
$ demoscript.m
```

You'll notice there is a 4-subplot figure still open; that's only for debugging purposes. Feel free to close it. You now have an 360-degree rotation video of the mesh at `data/hand/test.mp4`. Now we need to extract the video in the terminal, this is where python takes over.

## Python

Install the dependencies

```
user@/MATLAB$ pip install -r requirements.txt
```

Extract the images from the video

```
user@/MATLAB$ python utils/extract.py data/hand
```

There should now be a folder called `data/hand/observed` with the 17 images.

Run the demo (but don't run it just yet!)

```
user@/MATLAB$ ./demos/demoscript.sh
```

`demoscript.sh`
```
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
```

All `demoscript.sh` is is a wrapper around the scripts in `python/`. At the end (in about 15 minutes), there will a series of improved weights, numpy files, and a list of 17 probabilities on whether the image resembles a clubbed finger.

**NOTE:** since this build takes so long, I've included the *.npy and *.h5 files that are required. Now you can just run:

```
user@/MATLAB$ python python/predict.py data/test 2
```

Instead of running `demoscript.sh`

The low probability is the non-clubbed finger and the high probability is the clubbed finger.
