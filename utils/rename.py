import os
import sys
from pprint import PrettyPrinter

if len(sys.argv) < 2:
    print('usage: ./rename.py <path-to-images>')
    exit(1)
pp = PrettyPrinter(indent=2)

change = dict()
files = [f for f in os.listdir(
    sys.argv[1]) if 'rgb' not in f and 'rename' not in f]
rgb_files = [f for f in os.listdir(sys.argv[1]) if 'rgb' in f]
translate = {
    'r_': 'right_',
    'l_': 'left_'
}


def fullpath(image):
    return '{0}/{1}'.format(sys.argv[1], image)


for rgb in rgb_files:
    side = rgb.split('_')[0] + '_'
    path = fullpath(rgb)
    os.rename(path, path.replace(side, translate[side]))

for f in sorted(files, key=lambda x: int(x.split('_')[1].split('.')[0])):
    change[f] = f
    if '_1.jpg' in f:
        continue
    side, rest = f.split('_')
    index, ext = rest.split('.')
    if int(index) % 2 == 0:
        new_index = int(int(index) / 2)
        change[f] = '{0}_{1}_i.{2}'.format(
            side, new_index, ext)
    else:
        new_index = int((int(index) + 1) / 2)
        change[f] = '{0}_{1}.{2}'.format(
            side, new_index, ext)
    os.rename(fullpath(f), fullpath(change[f]))
pp.pprint(change)
