%% ������� 
% �����ʵ��ѧͼ�����Ŷ�-�º�
% ���˲��� www.aomanhao.top
% Github https://github.com/AomanHao
%--------------------------------------

clear
close all
clc
%% %%%%%%%%%%%%%%%ͼ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I=imread('3096.jpg');
if size(I,3) == 3
   I_Gray=rgb2gray(I);
else
end

%% ��ɫ���߻�ͼ��ȥ�룬��ֵ�˲��������ֵ��
r=3;%���򴰴�С
[I_mean,I_median]=compute_mean_median(I_Gray,r) ;
figure;imshow(I_mean,[]);title('�ֲ���ֵ');

%% LC
I_lc=LC_His(I_Gray);  
figure; imshow(I_lc);title('������ͼ��');
