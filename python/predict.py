import sys

import numpy as np
from keras import backend as K
from keras.layers import (Activation, Conv2D, Dense, Dropout, Flatten,
                          MaxPooling2D)
from keras.models import Model, Sequential, load_model
from keras.preprocessing.image import ImageDataGenerator

if len(sys.argv) < 3:
    print('usage: ./predict.py <path-to-images> <number-of-test-images>')
    exit(1)

img_width, img_height = 150, 150
batch_size = 5

# load tuned model
model = load_model('tuned.h5')
# test against files in data/test/observed
datagen = ImageDataGenerator(rescale=1. / 255)
generator = datagen.flow_from_directory(sys.argv[1], batch_size=batch_size, target_size=(
    img_width, img_height), classes=['observed'])
test_data_features = model.predict_generator(
    generator, int(sys.argv[2]) / (2 if sys.argv[2] != '1' else 1), verbose=1)
np.save(open('test_data_features.npy', 'wb'), test_data_features)
test_data = np.load(open('test_data_features.npy', 'rb'))
print(test_data)
