function dark=darkChannel(imRGB)
r=imRGB(:,:,1);           %�ֱ���ȡͼ�������ͨ��
g=imRGB(:,:,2);
b=imRGB(:,:,3);

[m,n]=size(r);            %��ȡͼ��ĳߴ�
a=zeros(m,n);             %��ȡһ��m*n��С��0����
for i=1:m                 %��ȡ��ͨ��
    for j=1:n
        a(i,j)=min(r(i,j),g(i,j));
        a(i,j)=min(a(i,j),b(i,j));
    end
end
dark=a;