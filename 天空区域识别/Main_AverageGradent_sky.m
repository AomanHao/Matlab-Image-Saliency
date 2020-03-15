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



%% 天空区域识别分离




%% 去雾
imageRGB = im2double(img);
figure;imshow(imageRGB), title('原始图像');


dark=darkChannel(imageRGB);
figure;imshow(dark);title('暗通道图像');
[m,n,~] = size(imageRGB);

%% 估计大气光值A，从暗通道中按亮度大小提取最亮的前0.1%像素。然后在原始有雾图像I中寻找对应位置上的具有最亮亮度的点的值，并以此作为A的值
imsize = m * n;
numpx = floor(imsize/1000);
JDarkVec = reshape(dark,imsize,1);
ImVec = reshape(imageRGB,imsize,3);

[JdarkVec, indices] = sort(JDarkVec);
indices = indices(imsize-numpx+1:end);

atmSum = zeros(1,3);
for ind = 1:numpx
    atmSum = atmSum + ImVec(indices(ind),:);
end
atmospheric = atmSum / numpx;
A = min(atmospheric); % 大气光值

omega = 0.8;
im = zeros(size(imageRGB));

%% 求透射率t
for ind = 1:3
    im(:,:,ind) = imageRGB(:,:,ind)./atmospheric(ind);
end
dark_2=darkChannel(im);%P15页对大气光归一化以后求取暗通道
t = 1-omega*dark_2;%对透射率粗估计
figure,imshow(t), title('原始透射图');
t_d=t;
t(t<0.1)=0.1;
figure,imshow(t), title('原始透射图');

% %% 双边滤波透射图
% filter=0.9*bfltGray(t,1,3,0.1);
% t_d = filter;
% figure,imshow(t_d), title('双边滤波后透射图');

img_d = double(imageRGB);

%% 去雾图像
J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;

figure,imshow(J), title('去雾图像');