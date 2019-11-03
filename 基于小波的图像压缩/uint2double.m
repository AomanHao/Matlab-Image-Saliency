function [y]=uint2double(x,scale,diff_matrix)
z=x.*scale;
z=z+diff_matrix;
y=z;