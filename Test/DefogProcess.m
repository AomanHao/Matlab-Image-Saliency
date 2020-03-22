function  [out,A] = DefogProcess(imageRGB,beta)


%% ȥ��
% imageRGB = im2double(img);
% figure;imshow(imageRGB), title('ԭʼͼ��');
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
A=max(A,beta);

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

figure,imshow(uint8(J)), title('ȥ��ͼ��');
out = J;