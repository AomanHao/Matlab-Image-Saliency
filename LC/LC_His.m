function center=LC_His(im)
[x1 y1 z]=size(im);
% im=rgb2gray(im);
zj=zeros(1,256);
dist=zeros(1,256);
hist_im=imhist(im); %计算直方图
sum=0;
% figure;
% bar(hist_im);%画直方图
for i=1:256
    for j=1:256
        sum=sum+(abs(i-j)*hist_im(j))^2; %论文中的公式。每个像素到其他像素的欧氏距离和      
    end
    zj(i)=sum^0.5;
    sum=0;
end
% figure;
%  bar(zj);%画直方图     
 small=min(zj);
 big=max(zj);
 ddist=big-small;
 for i=1:256
        dist(i) = (zj(i)-small)/ddist*256;		%归一化直方图
 end	
%  figure;
%  bar(dist);%画直方图     
 
 for a=1:x1
     for b=1:y1
         for z=1:255
             if im(a,b)==z
                 im(a,b)=dist(z);%计算每个像素的显著值
                 break;
             end
         end
     end
 end
 im=mat2gray(im);