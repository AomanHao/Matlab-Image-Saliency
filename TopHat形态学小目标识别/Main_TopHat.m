clear
clc
close all
format long 
a=imread('3096.jpg');
%length(size(a)) ���length��������ķ���ֵΪ3�����ͼ��Ϊ��ɫͼ���ΪRGB��ΪHSV
x=rgb2gray(a); %��ͼ��ת��Ϊ�Ҷ�ͼ��
figure(1)
imshow(x);



%����top-hat(��ñ�任:ԭͼ���ȥ��������ͼ��Ĺ��̣�
se1=strel('disk',15);%diamond ���νṹԪ�أ�diskԲ���ͽṹԪ�أ�line���ԽṹԪ�أ�octagon �˱��νṹԪ��
f0=imopen(x,se1);%�����㣨����ȥ���ȽṹԪ�ظ�С������ϸ�ڣ�
figure(2)
imshow(f0);
f1=imsubtract(x,f0);
figure(3)
imshow(f1);



%%%%%%%%%��f1����ά�Ҷ�ͼ%%%%%%%%
%[c,b]=size(f1);                 % ȡ��ͼ���С
%[X,Y]=meshgrid(1:b,1:c);        % ������������
%c=double(f1);                   % uint8 ת��Ϊ double   8λ�޷�����ת��Ϊ˫��������
%figure(4)
%mesh(X,Y,c);                    % ��ͼ



%%%%%��f1������ֵ�ָ�%%%%%%
%%%%�������������ֵ���зָ�%%%%%%
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
figure(6)
imshow(BW);


%%%%%%%%����ֵͼ����С�����P������ȥ��%%%%
P=100;   %PΪ�趨���
CONN=8;
BW2 = bwareaopen(BW,P,CONN); %ɾ����ֵͼ��BW�����С��P�Ķ���
figure(7)
imshow(BW2);
%hold on


%%%%%%%��ֵͼ���ж�Բ�ν�����ȡ%%%%%%%%%
t=0;
L=bwlabel(BW2);
STATS=regionprops(L,'Area','Perimeter','Centroid');  %��ȡͼ���и��������������ܳ�������
[m,n]=size(STATS);
H=zeros(m,n);
for i=1:m
    H(i)=(STATS(i).Perimeter)^2/STATS(i).Area;%�������������ܶȣ����ܶ�ԽСԽ�ӽ�Բ��
end
t=H(1,1);
s=1;
for i=2:m
    if t>H(i,1)
        t=H(i,1);
        s=i;
    end
end


%%%%%%%����ֵͼ���ϵķ�Ŀ������ȥ��%%%%%%%%%%%
%����Բ��Ŀ���������ǿ����趨��������������ض�Ϊ0�������Ϳ��Խ���Ŀ��ȥ��



%%%%%%��ԭͼ����С���α��Ŀ��%%%%%%%
R=STATS(s).Centroid(1,1);
T=STATS(s).Centroid(1,2);
D=25;
figure(8)
imshow(a);
rectangle('position',[(R-D/2) (T-D/2) D D] );%����(R��T)Ϊ���ĵı߳�ΪD��������

        

    
    


















