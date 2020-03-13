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
img=imread('foggy_bench.jpg');

if size(img,3) == 3
   I=rgb2gray(img);
else
end
I=im2double(I);
figure;imshow(I);title('(a)原始图像')
[m,n]=size(I);

% imhist(I);
% tabulate(I(:))%分布概率

%% 阈值
M=I;
M(M<=0.6)=0;
M(M>0.6)=1;
figure;imshow(M);title('(阈值');
se=3; % the parameter of structuing element used for morphological reconstruction
data_M=w_recons_CO(M,strel('square',se));

figure;imshow((data_M));title('去噪阈值');

%%  梯度法
T=0.02;%阈值
I_gradient=zeros(m,n);I_grad=zeros(m,n);
for i=2:m-1
    for j=2:n-1
        I_gradient(i,j)=abs(I(i+1,j)-I(i,j))+abs(I(i,j+1)-I(i,j));
        if I_gradient(i,j)<T
            I_grad(i,j)=0;
        else
            I_grad(i,j)=1;
        end
    end
end

se=3; % the parameter of structuing element used for morphological reconstruction
data=w_recons_CO(I_grad,strel('square',se));
figure;imshow((I_gradient));title('梯度信息');
% imhist(I_gradient);
% tabulate(I_gradient(:))%分布概率
figure;imshow((I_grad));title('梯度图');
figure;imshow((data));title('去噪梯度图');
abs_DATA = abs(data-1);figure;imshow((abs_DATA));title('去噪梯度');

% data1=w_recons_CO(I_gradient,strel('square',se));
% tabulate(data1(:))
%% 加权融合
K=imadd(data_M,abs_DATA,'uint16');        %使用imadd函数进行图像融合
figure,imshow(K,[])         %显示融合后的图


%% 融合
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

out = darkDefog(img);
