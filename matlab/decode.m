function [C,goodpixels] = decode(imageformat,start,stop,threshold)
% Input:
%
% imageformat : a string which is the prefix common to all the images.
%
%                  for example, pass in the prefix '/home/fowlkes/left/left_'
%                  to load the image sequence   '/home/fowlkes/left/left_01.jpg'
%                                               '/home/fowlkes/left/left_02.jpg'
%                                                          etc.
%  start : the first image # to load
%  stop  : the last image # to load
%
%  threshold : the pixel brightness should vary more than this threshold between the positive
%             and negative images.  if the absolute difference doesn't exceed this value, the
%             pixel is marked as undecodeable.
% Output:
%
%  C : an array containing the decoded values (0..1023)
%
%  goodpixels : a binary image in which pixels that were decodedable across all images are marked with a 1.
gbits = {};
bits = {};
images = [];
goodpixels = [];
index = 1;
h = 0;
w = 0;
product = 1;

% get all images in specified directory
[status, list] = system( sprintf('for n in %s*; do echo "$n"; done', imageformat) );
result = textscan( list, '%s', 'delimiter', '\n' );
images = natsortfiles(result{1});

realstart = 1;
if start ~= 1
  realstart = start*2-1;
end
images = images(realstart:stop*2);
% compare brightness and get good pixels
for i = 1:2:numel(images);
  image1 = im2double(rgb2gray(imread(images{i+1})));
  image2 = im2double(rgb2gray(imread(images{i})));
  gbits{index} = image1 > image2;
  goods = abs(image1 - image2) > threshold;
  if i == 1
    goodpixels = goods;
  else
    goodpixels = goodpixels & goods;
  end
  index = index + 1;
end

% convert grey to binary
bits{1} = gbits{1};
for j = 2:numel(gbits)
  bits{j} = xor(bits{j-1}, gbits{j});
end

% convert binary to decimal
C = product .* bits{numel(bits)};
for j = numel(bits)-1:-1:1
  product = product * 2;
  C = C + (product .* bits{j});
end
