%% 程序分享 
% 西安邮电大学图像处理团队-郝浩
% 个人博客 www.aomanhao.top
% Github https://github.com/AomanHao
% 基于小波的图像压缩方法——游程编码
%--------------------------------------

clear
close all
clc
%% %%%%%%%%%%%%%%%图像%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
I=imread('lena.bmp');
figure;imshow(I);title('原始图象'); 
I_or=double(I);
tImg=wavelet('2D D5',3,I_or,'sym');
tImage=uint8(tImg);             
figure; 
imshow(tImage);
Img=zeros(512,512);
Img(1:256,1:256)=tImg(1:256,1:256);
[Image,sc,dmatrix]=double2uint(Img);  %调整系数
x=select(Image);
code=RLC(x);
%% %%%%%%%%%%%%%%%%%解码部分%%%%%%%%%%%%%%%%%%
Image=dec(code);
Image_r=uint2double(Image,sc,dmatrix);
I_wa=wavelet('2D D5',-3,Image_r,'sym');
I_wa=uint8(I_wa);
figure;imshow(I_wa);
title('恢复图象'); 
diff=I-I_wa;
%figure;imshow(diff);
e=sum(sum(diff))/(sum(sum(I)));
total_infor=512*512;
[code_r,code_c]=size(code);pp=(512*512)/code_c;
disp(['压缩前的图像字节数为:',int2str(total_infor)]);
disp(['压缩后的图像字节数为:',int2str(code_c)]);
disp(['压缩率为:',num2str(pp),':1']);
disp(['压缩误差为：',num2str(e)]);
I_or = double(I_or)/256;
I_wa=double(I_wa)/256;
Y = PSNR(I_or, I_wa);
fprintf('PSNR = %fdB\n',Y);
toc;
tt = toc;
fprintf('运算时间:%fs\n',tt);