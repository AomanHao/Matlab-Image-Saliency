%% ������� 
% �����ʵ��ѧͼ�����Ŷ�-�º�
% ���˲��� www.aomanhao.top
% Github https://github.com/AomanHao
%--------------------------------------

clear
close all
clc
%% %%%%%%%%%%%%%%%ͼ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I=imread('Haze.jpg');
% I=imread('tiananmen1.png');
I=imread('foggy_bench.jpg');

if size(I,3) == 3
   I=rgb2gray(I);
else
end
I=im2double(I);
figure;imshow(I);title('(a)ԭʼͼ��')
[m,n]=size(I);

%% ��ֵ
M=I;
M(M<=0.6)=0;
M(M>0.6)=1;
figure;imshow(M);title('(��ֵ');
se=3; % the parameter of structuing element used for morphological reconstruction
data_M=w_recons_CO(M,strel('square',se));

figure;imshow((data_M));title('yuzhi');


%%  �ݶȷ�
T=0.02;%��ֵ
I_gradient=zeros(m,n);
for i=2:m-1
    for j=2:n-1
        I_gradient(i,j)=abs(I(i+1,j)-I(i,j))+abs(I(i,j+1)-I(i,j));
        if I_gradient(i,j)<T
            I_gradient(i,j)=0;
        else
            I_gradient(i,j)=255;
        end
    end
end

se=3; % the parameter of structuing element used for morphological reconstruction
data=w_recons_CO(I_gradient,strel('square',se));
figure;imshow(uint8(I_gradient));title('�ݶȷ�');
figure;imshow(uint8(data));title('�ݶȷ�');
abs_DATA = abs(data-255);figure;imshow((abs_DATA));title('�ݶ�');
%% ƽ���ݶ�
I=double(I);
% [M,N,K]=size(I);
sum=0;
for i=1:m-1
    for j=1:n-1
        diffX(i,j)=I(i,j)-I(i+1,j);
        diffY(i,j)=I(i,j)-I(i,j+1);
        w(i,j)=sqrt(((diffX(i,j))^2+(diffY(i,j))^2)/2);
        sum=sum+w(i,j);
    end
end



diffX_a = mapminmax(diffX);
figure;imshow(diffX_a);
diffY_a = mapminmax(diffY);
figure;imshow(diffY_a);
W_a = mapminmax(w);
figure;imshow(W_a);

AVEGRAD=sum/((m-1)*(n-1));

