%% ������� 
% ���˲��� www.aomanhao.top
% Github https://github.com/AomanHao
% CSDN https://blog.csdn.net/Aoman_Hao
%--------------------------------------
clear
close all
clc
%% %%%%%%%%%%%%%%%ͼ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I=imread('3096.jpg');

if size(img,3) == 3
   I=rgb2gray(img);
else
end
I=im2double(I);
figure;imshow(I);title('(a)ԭʼͼ��')
[m,n]=size(I);

% imhist(I);
% tabulate(I(:))%�ֲ�����



