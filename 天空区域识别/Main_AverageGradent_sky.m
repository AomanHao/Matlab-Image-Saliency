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
            I_gradient(i,j)=1;
        end
    end
end

se=3; % the parameter of structuing element used for morphological reconstruction
data=w_recons_CO(I_gradient,strel('square',se));
figure;imshow((I_gradient));title('�ݶȷ�');
figure;imshow((data));title('�ݶȷ�');
abs_DATA = abs(data-1);figure;imshow((abs_DATA));title('�ݶ�');


K=imadd(data_M,abs_DATA,'uint16');        %ʹ��imadd��������ͼ���ں�
figure,imshow(K,[])         %��ʾ�ںϺ��ͼ


%% �ں�

% X1=double(X1)/255;  %����ת����double���ͣ�����ʹ��С���任����Ļ��д�������1�Ĵ��ڣ��ᵼ��ͼ����ʾ������
% X1=rgb2gray(X1); ?%ԭ����ΪС���任ֻ��ʹ��һά�ģ���������ʹ��3ά

[c1,s1]=wavedec2(data_M,2,'sym4'); %��x1����2ά��ʹ�á�sym4�����б任

sizec1=size(c1);
for I=1:sizec1(2)
    c1(I)=1.2*c1(I); % ���ֽ���ֵ������1.2��
end
[c2,s2]=wavedec2(abs_DATA,2,'sym4');
c=c1+c2;     %����ƽ��ֵ
c=0.5*c;
s=s1+s2;
s=0.5*s;
xx=waverec2(c,s,'sym4');  %�����ع�
figure;
imshow(xx),title('�ںϺ��');


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

