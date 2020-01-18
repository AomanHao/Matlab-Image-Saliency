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
   I=rgb2gray(I);
else
end
I=im2double(I);
figure;imshow(I);title('(a)ԭʼͼ��')
[m,n]=size(I);

% I=I;%��������
%I=imnoise(I,'speckle',deta_2);
% I=imnoise(I,'salt & pepper',0.05); %�ӽ�������
% I=imnoise(I,'gaussian',0,0.01); % �Ӹ�˹����
figure;imshow(I);title('(b)����ͼ��');

%%  �ݶȷ�
T=20;%��ֵ
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
figure(1);subplot(2,3,1);imshow(uint8(I_gradient));title('�ݶȷ�');
 
%% roberts����
I_r=zeros(m,n);
for i=2:m-1
    for j=2:n-1
        I_r(i,j)=abs(I(i+1,j+1)-I(i,j))+abs(I(i,j+1)-I(i+1,j));
        if I_r(i,j)<T
            I_r(i,j)=0;
        else
            I_r(i,j)=255;
        end
    end
end
I_r=imbinarize(imfilter(I,r),T);
subplot(2,3,2);imshow(uint8(I_r));title('Roberts����');
 
%% prewitt����
I_prewitt=zeros(m,n);
for i=2:m-1
    for j=2:n-1
        I_prewitt(i,j)=abs(I(i-1,j-1)+I(i,j-1)+I(i+1,j-1)-I(i-1,j+1)-I(i,j+1)-I(i+1,j+1))+abs(I(i+1,j-1)+I(i+1,j)+I(i+1,j+1)-I(i-1,j-1)-I(i-1,j)-I(i-1,j+1));
        if I_prewitt(i,j)<15
            I_prewitt(i,j)=0;
        else
            I_prewitt(i,j)=255;
        end
    end
end
subplot(2,3,3);imshow(uint8(I_prewitt));title('Prewitt����');
 
%% sobel����
I_sobel=zeros(m,n);
for i=2:m-1
    for j=2:n-1
        I_sobel(i,j)=abs(I(i-1,j-1)+2*I(i,j-1)+I(i+1,j-1)-I(i-1,j+1)-2*I(i,j+1)-I(i+1,j+1))+abs(I(i+1,j-1)+2*I(i+1,j)+I(i+1,j+1)-I(i-1,j-1)-2*I(i-1,j)-I(i-1,j+1));
        if I_sobel(i,j)<T
            I_sobel(i,j)=0;
        else
            I_sobel(i,j)=255;
        end
    end
end
subplot(2,3,4);imshow(uint8(I_sobel));title('Sobel����');
 
 
%% LoG����
log1=[0 0 -1 0 0;
    0 -1 -2 -1 0;
    -1 -2 16 -2 -1;
    0 -1 -2 -1 0;
    0 0 -1 0 0];
 
I_l=conv2(I,log1,'same');
I_log=imbinarize(abs(I_l),300);
subplot(2,3,6);imshow(I_log);title('LoG����');

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

AVEGRAD=sum/((m-1)*(n-1))

