function [] = reconstruct(directory, threshold)
% Input:
%
%  threshold : the pixel brightness should vary more than this threshold between the positive
%             and negative images.  if the absolute difference doesn't exceed this value, the
%             pixel is marked as undecodeable.

rpath = sprintf('%s/r_', directory);
lpath = sprintf('%s/l_', directory);
camL.f = [ 1856.90556 1863.13475 ];
camL.c = [ 1403.64394 869.11608 ];
camR.f = [ 1844.49412 1843.96528 ];
camR.c = [ 1376.02154 942.95783 ];
[camL,xL,Xtrue] = calibrate_planar_ext(sprintf('%s/l_calib_01.jpg', directory), camL);
[camR,xR,Xtrue] = calibrate_planar_ext(sprintf('%s/r_calib_01.jpg', directory), camR);
% load each image set
disp('processing image set 1');
[Rv_C, Rv_goodpixels] = decode(rpath, 1, 10, threshold);
disp('processing image set 2');
[Rh_C, Rh_goodpixels] = decode(rpath, 11, 20, threshold);
disp('processing image set 3');
[Lv_C, Lv_goodpixels] = decode(lpath, 1, 10, threshold);
disp('processing image set 4');
[Lh_C, Lh_goodpixels] = decode(lpath, 11, 20, threshold);
[h w] = size(rgb2gray(im2double(imread(strcat(lpath, '01.jpg')))));

R_C = Rh_C + 1024*Rv_C;    % combine the horizontal and vertical coordinates into a single (20 bit) code in [0...1048575]
L_C = Lh_C + 1024*Lv_C;
R_goodpixels = Rh_goodpixels & Rv_goodpixels; %identify pixels that have both good horiztonal and vertical codes
L_goodpixels = Lh_goodpixels & Lv_goodpixels;

R_sub = find(R_goodpixels);     % find the indicies of pixels that were succesfully decoded
L_sub = find(L_goodpixels);
R_C_good = R_C(R_sub);          % pull out the codes for the good pixels
L_C_good = L_C(L_sub);

%intersect the codes of good pixels in the left and right image to find matches
[matched,iR,iL] = intersect(R_C_good,L_C_good);

R_sub_matched = R_sub(iR);  % get the pixel indicies of the pixels that were matched
L_sub_matched = L_sub(iL);
[xx,yy] = meshgrid(1:w,1:h); % create arrays containing the pixel coordinates

X = triangulate(xL, xR, camL, camR);
disp('saving to reconstruct.mat...');
save('reconstruct.mat', 'X', 'xL', 'xR');
axis([-10 50 -10 50 -10 50]);
plot3(X(1,:), X(2,:), X(3,:), '.');
subplot(2,2,1);
imagesc(Rh_C);
title('Right Cam; Horizontal');
subplot(2,2,2);
imagesc(Rv_C);
title('Right Cam; Vertical');
subplot(2,2,3);
imagesc(Lh_C);
title('Left Cam; Horizontal');
subplot(2,2,4);
imagesc(Lv_C);
title('Left Cam; Vertical');