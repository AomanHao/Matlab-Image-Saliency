%����ƽ���ݶ�
clear all
close all
clear
[filename,pathname]=uigetfile('*.*','ͼ��');
A=imread([pathname,filename]);
%s=size(size(A));

%if s(2)==3
%    A=rgb2gray(A);
%end
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