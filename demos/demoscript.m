function [] = demoscript()
addpath('../matlab');
reconstruct('../data/hand/set_2', 0.02);
mesh(0.02);
restoredefaultpath
