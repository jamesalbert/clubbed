function [] = mesh(threshold)
% render the mesh loaded in by `reconstruct.mat`
% Input:
%
%  threshold : a factor of the mean of all distances between edges. I found
%              the best results with threshold=6
load('reconstruct.mat', 'X', 'xL', 'xR');

tri = delaunay(xL(1,:), xL(2,:)).';

% % filter edges too far apart
% p1 = X(:, tri(1,:));
% p2 = X(:, tri(2,:));
% p3 = X(:, tri(3,:));
% d12 = sum((p1-p2).^2,1).^0.5 < mean(sum((p1-p2).^2,1).^0.5) * threshold;
% d13 = sum((p1-p3).^2,1).^0.5 < mean(sum((p1-p3).^2,1).^0.5) * threshold;
% d23 = sum((p2-p3).^2,1).^0.5 < mean(sum((p2-p3).^2,1).^0.5) * threshold;
%
% % filter points that are out of frame of interest
% tri_new = tri(:,d12 & d13 & d23);
% % 30x10x20 seems to be the bounding
% % box that captures the mesh the best
% p1 = X(1, tri_new(1,:)) < 30;
% p2 = X(2, tri_new(2,:)) > 10;
% p3 = X(3, tri_new(3,:)) < 20;
% tri_clean = tri_new(:,p1 & p2 & p3);

% display the mesh
figure(1); clf;
h = trisurf(tri.',X(1,:),X(2,:),X(3,:));
set(h,'edgecolor','none')
set(gca,'projection','perspective')
set(gcf,'renderer','opengl')
axis image; axis vis3d;
camorbit(120,0); camlight left;
camorbit(120,0); camlight left;
lighting phong;
material dull;
