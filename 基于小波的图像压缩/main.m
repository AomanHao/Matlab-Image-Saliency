%% ������� 
% �����ʵ��ѧͼ�����Ŷ�-�º�
% ���˲��� www.aomanhao.top
% Github https://github.com/AomanHao
% ����С����ͼ��ѹ�����������γ̱���
%--------------------------------------

clear
close all
clc
%% %%%%%%%%%%%%%%%ͼ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
I=imread('lena.bmp');
figure;imshow(I);title('ԭʼͼ��'); 
I_or=double(I);
tImg=wavelet('2D D5',3,I_or,'sym');
tImage=uint8(tImg);             
figure; 
imshow(tImage);
Img=zeros(512,512);
Img(1:256,1:256)=tImg(1:256,1:256);
[Image,sc,dmatrix]=double2uint(Img);  %����ϵ��
x=select(Image);
code=RLC(x);
%% %%%%%%%%%%%%%%%%%���벿��%%%%%%%%%%%%%%%%%%
Image=dec(code);
Image_r=uint2double(Image,sc,dmatrix);
I_wa=wavelet('2D D5',-3,Image_r,'sym');
I_wa=uint8(I_wa);
figure;imshow(I_wa);
title('�ָ�ͼ��'); 
diff=I-I_wa;
%figure;imshow(diff);
e=sum(sum(diff))/(sum(sum(I)));
total_infor=512*512;
[code_r,code_c]=size(code);pp=(512*512)/code_c;
disp(['ѹ��ǰ��ͼ���ֽ���Ϊ:',int2str(total_infor)]);
disp(['ѹ�����ͼ���ֽ���Ϊ:',int2str(code_c)]);
disp(['ѹ����Ϊ:',num2str(pp),':1']);
disp(['ѹ�����Ϊ��',num2str(e)]);
I_or = double(I_or)/256;
I_wa=double(I_wa)/256;
Y = PSNR(I_or, I_wa);
fprintf('PSNR = %fdB\n',Y);
toc;
tt = toc;
fprintf('����ʱ��:%fs\n',tt);