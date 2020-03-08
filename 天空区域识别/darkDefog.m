function out = darkDefog(image)
image=image./255;
figure;
%subplot(2,1,1);
imshow(image), title('ԭʼͼ��');
% imwrite(imageRGB(2:516,2:689,:),'D:\����ȥ�����\�½��ļ���\˫���˲�ȥ��\˫�߽���7(1)ȥ���.bmp');
% subplot(2,1,2);imhist(rgb2gray(imageRGB));
% imageRGB=imnoise(imageRGB,'gaussian',0.02);
% figure;
% imshow(imageRGB);title('����ͼ');
sz=size(image);
w=sz(2);
h=sz(1);

dark=darkChannel(image);
figure,imshow(dark);
title('��ͨ��ͼ��');
% imwrite(dark,'traffic_1.jpg')
[m,n,~] = size(image);
%���ƴ�����ֵA���Ӱ�ͨ���а����ȴ�С��ȡ������ǰ0.1%���ء�Ȼ����ԭʼ����ͼ��I��Ѱ�Ҷ�Ӧλ���ϵľ����������ȵĵ��ֵ�����Դ���ΪA��ֵ
imsize = m * n;
numpx = floor(imsize/1000);
JDarkVec = reshape(dark,imsize,1);
ImVec = reshape(image,imsize,3);

[JdarkVec, indices] = sort(JDarkVec);
indices = indices(imsize-numpx+1:end);

atmSum = zeros(1,3);
for ind = 1:numpx
    atmSum = atmSum + ImVec(indices(ind),:);
end
atmospheric = atmSum / numpx;

omega = 0.8;
im = zeros(size(image));

for ind = 1:3
    im(:,:,ind) = image(:,:,ind)./atmospheric(ind);
end
dark_2=darkChannel(im);%P15ҳ�Դ������һ���Ժ���ȡ��ͨ��
t = 1-omega*dark_2;%��͸���ʴֹ���
figure,imshow(t), title('ԭʼ͸��ͼ');
% imwrite(t,'traffic_2.jpg')
filter=0.9*bfltGray(t,1,3,0.1);
t_d = filter;
figure,imshow(t_d), title('˫���˲���͸��ͼ');
% imwrite(t_d,'traffic_3.jpg')
A = min(atmospheric);
% figure,imshow(t_d,[]),title('�˲��� t');
img_d = double(image);
% t_d = imadjust(t_d,[],[],0.5);
%J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
%figure,imshow(J(:,:,1));
%imwrite(J(:,:,1),'D:\����\ѧϰ\�½��ļ���\˫���˲�ȥ��\r.JPG');
%J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
%figure,imshow(J(:,:,2));
%imwrite(J(:,:,2),'D:\����\ѧϰ\�½��ļ���\˫���˲�ȥ��\g.JPG');
%J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;
%figure,imshow(J(:,:,3));
%imwrite(J(:,:,3),'D:\����\ѧϰ\�½��ļ���\˫���˲�ȥ��\b.JPG');

J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./t_d;
J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./t_d;
J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./t_d;
%{
K=1;
J(:,:,1) = (img_d(:,:,1) - (1-t_d)*A)./min(max(K./(img_d(:,:,1)-A),1).*max(t_d,0.1),1);
J(:,:,2) = (img_d(:,:,2) - (1-t_d)*A)./min(max(K./(img_d(:,:,1)-A),1).*max(t_d,0.1),1);
J(:,:,3) = (img_d(:,:,3) - (1-t_d)*A)./min(max(K./(img_d(:,:,1)-A),1).*max(t_d,0.1),1);
%}
figure,imshow(J), title('ȥ��ͼ��');
out = J;