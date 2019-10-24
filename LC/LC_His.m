function center=LC_His(im)
[x1 y1 z]=size(im);
% im=rgb2gray(im);
zj=zeros(1,256);
dist=zeros(1,256);
hist_im=imhist(im); %����ֱ��ͼ
sum=0;
% figure;
% bar(hist_im);%��ֱ��ͼ
for i=1:256
    for j=1:256
        sum=sum+(abs(i-j)*hist_im(j))^2; %�����еĹ�ʽ��ÿ�����ص��������ص�ŷ�Ͼ����      
    end
    zj(i)=sum^0.5;
    sum=0;
end
% figure;
%  bar(zj);%��ֱ��ͼ     
 small=min(zj);
 big=max(zj);
 ddist=big-small;
 for i=1:256
        dist(i) = (zj(i)-small)/ddist*256;		%��һ��ֱ��ͼ
 end	
%  figure;
%  bar(dist);%��ֱ��ͼ     
 
 for a=1:x1
     for b=1:y1
         for z=1:255
             if im(a,b)==z
                 im(a,b)=dist(z);%����ÿ�����ص�����ֵ
                 break;
             end
         end
     end
 end
 im=mat2gray(im);
 figure;
 imshow(im);title('������');