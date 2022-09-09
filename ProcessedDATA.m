clear; clc; close all;
data = importdata('GT_data.mat');
GT_conc = extractfield(data, 'GT_conc'); % extracting field of interest from structure
[X,Y] = meshgrid(0.1:0.05:5.95, 0.1:0.05:5.95); % equivilant to grid used to generate data in GADEN
c = surf(Y,X,reshape(log(GT_conc),[118 118]));
colorbar
caxis([-3.5 5]);