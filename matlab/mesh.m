function [] = mesh(threshold)
% render the mesh loaded in by `reconstruct.mat`
% Input:
%
%  threshold : a factor of the mean of all distances between edges. I found
%              the best results with threshold=6
load('reconstruct.mat', 'X', 'xL', 'xR');

tri = delaunay(xL(1,:), xL(2,:)).';

% display the mesh
mov = VideoWriter('../data/hand/test.mp4', 'MPEG-4');
open(mov);
% code here to generate your nice 3D mesh rendering
f = figure(1); clf;
h = trisurf(tri.',X(1,:),X(2,:),X(3,:));
set(h,'edgecolor','none')
set(gca,'projection','perspective')
set(gcf,'renderer','opengl')
axis image; axis vis3d;
camorbit(120,0); camlight left;
camorbit(120,0); camlight left;
lighting phong;
material dull;
for i = 1:18
  camorbit(0,20);
  F = getframe(gcf);
  writeVideo(mov,F);
end
close(mov);
close(f);
