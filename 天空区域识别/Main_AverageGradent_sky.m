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
img=imread('foggy_bench.jpg');

if size(img,3) == 3
   I=rgb2gray(img);
else
end
I=im2double(I);
figure;imshow(I);title('(a)ԭʼͼ��')
[m,n]=size(I);

% imhist(I);
% tabulate(I(:))%�ֲ�����

%% ��ֵ
M=I;
M(M<=0.6)=0;
M(M>0.6)=1;
figure;imshow(M);title('(��ֵ');
se=3; % the parameter of structuing element used for morphological reconstruction
data_M=w_recons_CO(M,strel('square',se));

figure;imshow((data_M));title('ȥ����ֵ');

%%  �ݶȷ�
T=0.02;%��ֵ
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
figure;imshow((I_gradient));title('�ݶ���Ϣ');
% imhist(I_gradient);
% tabulate(I_gradient(:))%�ֲ�����
figure;imshow((I_grad));title('�ݶ�ͼ');
figure;imshow((data));title('ȥ���ݶ�ͼ');
abs_DATA = abs(data-1);figure;imshow((abs_DATA));title('ȥ���ݶ�');

% data1=w_recons_CO(I_gradient,strel('square',se));
% tabulate(data1(:))
%% ��Ȩ�ں�
K=imadd(data_M,abs_DATA,'uint16');        %ʹ��imadd��������ͼ���ں�
figure,imshow(K,[])         %��ʾ�ںϺ��ͼ


%% �ں�
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



%% �������ʶ�����




%% ȥ��
imageRGB = im2double(img);
figure;imshow(imageRGB), title('ԭʼͼ��');


dark=darkChannel(imageRGB);
figure;imshow(dark);title('��ͨ��ͼ��');
[m,n,~] = size(imageRGB);

%% ���ƴ�����ֵA���Ӱ�ͨ���а����ȴ�С��ȡ������ǰ0.1%���ء�Ȼ����ԭʼ����ͼ��I��Ѱ�Ҷ�Ӧλ���ϵľ����������ȵĵ��ֵ�����Դ���ΪA��ֵ
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
A = min(atmospheric); % ������ֵ

omega = 0.8;
im = zeros(size(imageRGB));

%% ��͸����t
for ind = 1:3
    im(:,:,ind) = imageRGB(:,:,ind)./atmospheric(ind);
end
dark_2=darkChannel(im);%P15ҳ�Դ������һ���Ժ���ȡ��ͨ��
t = 1-omega*dark_2;%��͸���ʴֹ���
figure,imshow(t), title('ԭʼ͸��ͼ');
t_d=t;
t(t<0.1)=0.1;
figure,imshow(t), title('ԭʼ͸��ͼ');

% %% ˫���˲�͸��ͼ
% filter=0.9*bfltGray(t,1,3,0.1);
% t_d = filter;
% figure,imshow(t_d), title('˫���˲���͸��ͼ');

img_d = double(imageRGB);

%% ȥ��ͼ��
J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;

figure,imshow(J), title('ȥ��ͼ��');