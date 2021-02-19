%% 程序分享 
% 个人博客 www.aomanhao.top
% Github https://github.com/AomanHao
% CSDN https://blog.csdn.net/Aoman_Hao
%--------------------------------------
clear
close all
clc
%% %%%%%%%%%%%%%%%图像%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img=imread('3096.jpg');

if size(img,3) == 3
    Result = Premea_cal (img);
else
    disp('img is not color');
end




img=im2double(img);
figure;imshow(img);title('(a)原始图像')
[m,n]=size(img);

% imhist(I);
% tabulate(I(:))%分布概率



