# clubbed

## Matlab

While this library is primarily written in Python, there are complement Matlab scripts used for scanning a hand and creating a three-dimensional mesh. It then takes 17 images of the hand; 1 image every 20 degrees about the y-axis. The recommended way of running this library would be the following inside the root Matlab directory:

```
user@/MATLAB$ git clone https://github.com/jamesalbert/clubbed.git
```

then in the **Matlab console**:

```
$ cd clubbed/demos
$ demoscript
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

Take a look at `demoscript.sh`:
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

## API Reference

### Matlab

**mapgrid.m**: this script pops up the calibration images in `data/hand/calib` used to calibrate the two cameras. Click the corners in the following order: 1st quadrant, 2nd quadrant, 3rd quadrant, 4th quadrant.

**calibrate_planar_ext.m**: this script helps calibrate the cameras before decoding and reconstruction begins. It takes in the path to the calibration image and a camera struct containing f (focal point) and c (principle points) attributes. It returns a new camera struct with R (rotation matrix) and t (transition vector) attributes, along with grid corner points, and true 3d space coordinates.

**project_error_ext.m**: this script is used inside `calibrate_planar_ext.m` to calculate projection errors. It's used to optimize the the rotation matrix and transition vector.

**project.m**: this script is used in `project_error_ext.m`. It uses the specified set of 3D coordinates and camera struct to project the points in 3D space from the view of the camera.

**triangulate.m**: this script takes two cameras and two corresponding 3D coordinates, and we use that data to calculate world coordinates for our mesh. This allows us to freely rotate/translate the mesh.

**decode.m**: this script takes a format string describing the images to decode, a start and stop index of the images, and a threshold by which corresponding pixels from different camera views may differ. It returns the decoded pixels (as 10-bit values) and a binary matrix describing which pixels are considered "good" (or within the specified threshold).

**reconstruct.m**: this script takes a path to the set of images (in demos/demoscript.m, we use `data/hand/set_2`) and a threshold used for purposes described in `decode.m`.

**mesh.m**: this script loads the `reconstruct.mat` file generated from `reconstruct.m` to display a 3D mesh of the hand. It also rotates a camera about the mesh along the y-axis to get a 360 degree view of the mesh. Each frame (taken once every 20 degrees along the rotation) will be used by the python code to determine if the hand has clubbed fingers.

**natsort.m** and **natsortfiles.m**: I downloaded `natsort.m` and `natsortfiles.m` (Natural Sort) from [Stephen Cobeldick](https://www.mathworks.com/matlabcentral/fileexchange/47434-natural-order-filename-sort). They are used to sort the files (list of images in this case) so that the following example set of files:

```
l_2_i.jpg l_1.jpg l_10.jpg
```

will be sorted as:

```
l_1.jpg l_2_i.jpg l_10.jpg
```

instead of:

```
l_1.jpg l_10.jpg l_2_i.jpg
```

### Python

**train.py**: performs the initial k-fold cross validation steps. Keras makes it incredibly simple to perform these tasks. All we need to do is create a model and tell it where the images are, and we're off with the initial training data stored as weights in `trained.h5`.

**optimize.py**: since the sample size is so small (320 training images, 20 validation images), it's recommended that we optimize the training by using ImageNet's pre-defined set of 22,000 different objects including hands. This part, in layman's terms, cuts out the overhead of the program trying to determine if the object in the image is a hand. After this generates `fc_model.h5`, we can use that weights file to instantly try to solve the problem: does this hand have clubbed fingers (as opposed to trying to figure out if it's a hand at all).

**tune.py**: fine tuning is a rather simple process of re-training the program, but with the newly generated `fc_model.h5` weights generated from `optimize.py`. It's pretty much the glue between `train.py` and `optimize.py`. You might notice that we only fine-tune the last convolution box (a basic component of the model) to prevent over-fitting. Overfitting occurs when the sample used to train the program is not sufficient enough to classify new images as one thing or nothing. If this occurs, we won't be able to know if a hand has clubbed fingers. This script generates the final weights file `tuned.h5`.

**predict.py**: uses the fine-tuned weights file `tuned.h5` to predict whether the object in the specified new images are indicative of a hand with clubbed fingers. This is the only python script that takes parameters and they are the path to the new images and how many images there are. In the demo, we specify `data/test` and 2.

#### Utilities

**extract.py**: this script extracts the frames out of an .mp4 video file. Specify the path to the video (without the video name) and it will create a directory there called `observed` where it will store the frames.

**get.py**: a browser automation script used for obtaining the images.

**rename.py**: a (otherwise useless) script I used to rename the image sets in order to be used in the matlab code. I used it in the beginning and thought I'd keep it for future use.
