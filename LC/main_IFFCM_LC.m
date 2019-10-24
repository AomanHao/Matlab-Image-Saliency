%% 程序分享 
% 西安邮电大学图像处理团队-郝浩
% 个人博客 www.aomanhao.top
% Github https://github.com/AomanHao
%--------------------------------------

clear
close all
clc
%% %%%%%%%%%%%%%%%图像%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I=imread('3096.jpg');
if size(I,3) == 3
   I_Gray=rgb2gray(I);
else
end

%% 彩色或者灰图像去噪，均值滤波（邻域均值）
r=3;%邻域窗大小
[I_mean,I_median]=compute_mean_median(I_Gray,r) ;
figure;imshow(I_mean,[]);title('局部均值');

%% LC
I_lc=LC_His(I_Gray);  
figure; imshow(I_lc);title('显著性图像');
