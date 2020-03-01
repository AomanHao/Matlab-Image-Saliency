%% 程序分享 
% 西安邮电大学图像处理团队-郝浩
% 个人博客 www.aomanhao.top
% Github https://github.com/AomanHao
%--------------------------------------

clear
close all
clc
%% %%%%%%%%%%%%%%%图像%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I=imread('Haze.jpg');
% I=imread('tiananmen1.png');
I=imread('foggy_bench.jpg');

if size(I,3) == 3
   I=rgb2gray(I);
else
end
I=im2double(I);
figure;imshow(I);title('(a)原始图像')
[m,n]=size(I);

%% 阈值
M=I;
M(M<=0.6)=0;
M(M>0.6)=1;
figure;imshow(M);title('(阈值');
se=3; % the parameter of structuing element used for morphological reconstruction
data_M=w_recons_CO(M,strel('square',se));

figure;imshow((data_M));title('yuzhi');

%%  梯度法
T=0.02;%阈值
I_gradient=zeros(m,n);
for i=2:m-1
    for j=2:n-1
        I_gradient(i,j)=abs(I(i+1,j)-I(i,j))+abs(I(i,j+1)-I(i,j));
        if I_gradient(i,j)<T
            I_gradient(i,j)=0;
        else
            I_gradient(i,j)=1;
        end
    end
end

se=3; % the parameter of structuing element used for morphological reconstruction
data=w_recons_CO(I_gradient,strel('square',se));
figure;imshow((I_gradient));title('梯度法');
figure;imshow((data));title('梯度法');
abs_DATA = abs(data-1);figure;imshow((abs_DATA));title('梯度');


K=imadd(data_M,abs_DATA,'uint16');        %使用imadd函数进行图像融合
figure,imshow(K,[])         %显示融合后的图


%% 融合

% X1=double(X1)/255;  %这里转化成double类型，否则使用小波变换输出的会有大量大于1的存在，会导致图像显示有问题
% X1=rgb2gray(X1); ?%原本以为小波变换只能使用一维的，看来可以使用3维

[c1,s1]=wavedec2(data_M,2,'sym4'); %将x1进行2维，使用‘sym4’进行变换

sizec1=size(c1);
for I=1:sizec1(2)
    c1(I)=1.2*c1(I); % 将分解后的值都扩大1.2倍
end
[c2,s2]=wavedec2(abs_DATA,2,'sym4');
c=c1+c2;     %计算平均值
c=0.5*c;
s=s1+s2;
s=0.5*s;
xx=waverec2(c,s,'sym4');  %进行重构
figure;
imshow(xx),title('融合后的');


%% 平均梯度
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

