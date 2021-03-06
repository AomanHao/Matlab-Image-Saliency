%% 程序分享 
% 西安邮电大学图像处理团队-郝浩
% 个人博客 www.aomanhao.top
% Github https://github.com/AomanHao
% 基于TopHat的图像滤波
%--------------------------------------

clear
clc
close all
format long 
%% %%%%%%%%%%%%%%%图像%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
I=imread('huo2.jpg');
figure;imshow(I);
% 彩色转灰度
if size(I,3) == 3
   x=rgb2gray(I);
else
end
figure;imshow(x);

%% 进行top-hat(顶帽变换:原图像减去开运算后的图像的过程）
se1=strel('disk',15);%diamond 菱形结构元素，disk圆盘型结构元素，line线性结构元素，octagon 八边形结构元素
f0=imopen(x,se1);%开运算（可以去除比结构元素更小的明亮细节）
figure;imshow(f0);
f1=imsubtract(x,f0);
figure;imshow(f1);title('顶帽');

%% %%%%%%%作f1的三维灰度图%%%%%%%%
[c,b]=size(f1);                 % 取出图像大小
[X,Y]=meshgrid(1:b,1:c);        % 生成网格坐标
c=double(f1);                   % uint8 转换为 double   8位无符号数转化为双精度类型
figure(4)
mesh(X,Y,c);                    % 画图

%% %%%对f1进行阈值分割%%%%%%
%%%%对其进行区间阈值进行分割%%%%%%
[width,height]=size(x);
BW=zeros(width,height);
for i=1:width
    for j=1:height
        if f1(i,j)>105
            if f1(i,j)<130
            BW(i,j)=1;
            end
        end
    end
end
figure;imshow(BW);title('阈值');

%% %%%%%%将二值图像中小于面积P的区域去掉%%%%
P=100;   %P为设定面积
CONN=8;
BW2 = bwareaopen(BW,P,CONN); %删除二值图像BW中面积小于P的对象
figure(7)
imshow(BW2);
%hold on

%% %%%%%二值图像中对圆形进行提取%%%%%%%%%
t=0;
L=bwlabel(BW2);
STATS=regionprops(L,'Area','Perimeter','Centroid');  %求取图像中各个区域的面积，周长和质心
[m,n]=size(STATS);
H=zeros(m,n);
for i=1:m
    H(i)=(STATS(i).Perimeter)^2/STATS(i).Area;%求各个区域的致密度，致密度越小越接近圆形
end
t=H(1,1);
s=1;
for i=2:m
    if t>H(i,1)
        t=H(i,1);
        s=i;
    end
end

%% %%%%在原图上做小矩形标记目标%%%%%%%
R=STATS(s).Centroid(1,1);
T=STATS(s).Centroid(1,2);
D=25;
figure;imshow(I);
rectangle('position',[(R-D/2) (T-D/2) D D] );%做以(R，T)为中心的边长为D的正方形

        

    
    


















