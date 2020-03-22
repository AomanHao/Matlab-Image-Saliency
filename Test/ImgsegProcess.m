function Out = ImgsegProcess(img,ind,m,n)
Out =zeros(m,n,3);
for i = 1:3
    A = img(:,:,i);
    A(ind) = -1;
    Out(:,:,i) = A;
end
figure;imshow(uint8(Out));
