%% 程序分享 
% 个人博客 www.aomanhao.top
% Github https://github.com/AomanHao
% CSDN https://blog.csdn.net/Aoman_Hao
%--------------------------------------
clear
close all
clc
%% %%%%%%%%%%%%%%%图像%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I=imread('3096.jpg');

if size(img,3) == 3
   I=rgb2gray(img);
else
end
I=im2double(I);
figure;imshow(I);title('(a)原始图像')
[m,n]=size(I);

% imhist(I);
% tabulate(I(:))%分布概率



