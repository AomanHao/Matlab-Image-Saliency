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
   I=rgb2gray(I);
else
end
I=im2double(I);
figure;imshow(I);title('(a)原始图像')
[m,n]=size(I);

% I=I;%不加噪声
%I=imnoise(I,'speckle',deta_2);
% I=imnoise(I,'salt & pepper',0.05); %加椒盐噪声
% I=imnoise(I,'gaussian',0,0.01); % 加高斯噪声
figure;imshow(I);title('(b)加噪图像');

%%  梯度法
T=20;%阈值
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
figure(1);subplot(2,3,1);imshow(uint8(I_gradient));title('梯度法');
 
%------roberts算子-------
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
%I_r=imbinarize(imfilter(I,r),T);
subplot(2,3,2);imshow(uint8(I_r));title('Roberts算子');
 
%------prewitt算子-------
I_p=zeros(m,n);
for i=2:m-1
    for j=2:n-1
        I_p(i,j)=abs(I(i-1,j-1)+I(i,j-1)+I(i+1,j-1)-I(i-1,j+1)-I(i,j+1)-I(i+1,j+1))+abs(I(i+1,j-1)+I(i+1,j)+I(i+1,j+1)-I(i-1,j-1)-I(i-1,j)-I(i-1,j+1));
        if I_p(i,j)<15
            I_p(i,j)=0;
        else
            I_p(i,j)=255;
        end
    end
end
subplot(2,3,3);imshow(uint8(I_p));title('Prewitt算子');
 
%------sobel算子-------
I_s=zeros(m,n);
for i=2:m-1
    for j=2:n-1
        I_s(i,j)=abs(I(i-1,j-1)+2*I(i,j-1)+I(i+1,j-1)-I(i-1,j+1)-2*I(i,j+1)-I(i+1,j+1))+abs(I(i+1,j-1)+2*I(i+1,j)+I(i+1,j+1)-I(i-1,j-1)-2*I(i-1,j)-I(i-1,j+1));
        if I_s(i,j)<T
            I_s(i,j)=0;
        else
            I_s(i,j)=255;
        end
    end
end
subplot(2,3,4);imshow(uint8(I_s));title('Sobel算子');
 
%------krisch算子-------
k(:,:,1)=[-3,-3,-3;
    -3,0,5;
    -3,5,5];
k(:,:,2)=[-3,-3,5;
    -3,0,5;
    -3,-3,5];
k(:,:,3)=[-3,5,5;
    -3,0,5;
    -3,-3,-3];
k(:,:,4)=[-3,-3,-3;
    -3,0,-3;
    5,5,5];
k(:,:,5)=[5,5,5;
    -3,0,-3;
    -3,-3,-3];
k(:,:,6)=[-3,-3,-3;
    5,0,-3;
    5,5,-3];
k(:,:,7)=[5,-3,-3;
    5,0,-3;
    5,-3,-3];
k(:,:,8)=[5,5,-3;
    5,0,-3;
    -3,-3,-3];
kk=zeros(size(I));
I=double(I);
for i=1:8
    I_k(:,:,i)=conv2(I,k(:,:,i),'same');
    kk=max(kk,I_k(:,:,i));
end
I_kk=imbinarize(kk,600);
subplot(2,3,5);imshow(I_kk);title('Krisch算子');
 
%------LoG算子-------
log1=[0 0 -1 0 0;
    0 -1 -2 -1 0;
    -1 -2 16 -2 -1;
    0 -1 -2 -1 0;
    0 0 -1 0 0];
 
I_l=conv2(I,log1,'same');
I_ll=imbinarize(abs(I_l),300);
subplot(2,3,6);imshow(I_ll);title('LoG算子');




%% 平均梯度
A=double(A);
[M,N,K]=size(A);
sum=0;

for i=1:M-1
    for j=1:N-1
        diffX(i,j)=A(i,j)-A(i+1,j);
        diffY(i,j)=A(i,j)-A(i,j+1);
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

AVEGRAD=sum/((M-1)*(N-1))

figure;imshow(labels2,[]);title('(c)聚类分割图');
imwrite(labels2,'3.1.tiff','tiff','Resolution',300);%输出结果，保存为tif图片

