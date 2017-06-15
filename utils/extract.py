import os
import shutil
import sys

import cv2

if len(sys.argv) < 2:
    print('usage: ./extract.py <path-to-video>')
    exit(1)
# remove observed_dir if exists
observed_dir = '{0}/observed'.format(sys.argv[1])
if os.path.isdir(observed_dir):
    shutil.rmtree(observed_dir)
os.mkdir(observed_dir)
# open test.mp4
vidcap = cv2.VideoCapture('{0}/test.mp4'.format(sys.argv[1]))
success, image = vidcap.read()
count = 0
success = True
while success:
    count += 1
    success, image = vidcap.read()
    print('Read a new frame: ', success)
    # save frame as image
    cv2.imwrite(
        "{0}/observed/finger_{1}.jpg".format(sys.argv[1], count), image)
os.remove("{0}/observed/finger_{1}.jpg".format(sys.argv[1], count))
