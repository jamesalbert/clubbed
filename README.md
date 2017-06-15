# clubbed

## Matlab

While this library is primarily written in Python, but there are complement Matlab scripts used for scanning a hand and creating a three-dimensional mesh. The recommended way of running this library would be do the following inside the root Matlab directory:

```
user@/MATLAB$ git clone https://github.com/jamesalbert/clubbed.git
user@/MATLAB/clubbed$ cd clubbed
```

## Setup

`pip install -r requirements.txt`

## Example

```
python train.py
python optimize.py
python tune.py
python predict.py <number-of-test-files>
```

where `<number-of-test-files>` is the number of files inside `data/test/observed`
