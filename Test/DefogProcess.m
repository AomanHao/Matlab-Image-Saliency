function  [out,A] = DefogProcess(imageRGB,beta)


%% 去雾
% imageRGB = im2double(img);
% figure;imshow(imageRGB), title('原始图像');
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
A=max(A,beta);

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

figure,imshow(uint8(J)), title('去雾图像');
out = J;