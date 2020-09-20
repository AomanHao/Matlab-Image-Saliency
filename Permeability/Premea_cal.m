function  Result = Premea_cal (img)

R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
[row, col] = size(img);
Num = zeros(1,3);
Mask = zeros(row, col);


for i =1:row
    for j = 1:col
       Num(1, 1)  = R(i, j);
       Num(1, 2)  = R(i, j);
       Num(1, 3)  = R(i, j);
    end
end

PointSize = round(row / 40)* 2 + 1;
KernelSize = (PointSize - 1)/2;
minMask = padarray(Mask, [KernelSize, KernelSize], 'symmetric', 'both'); %Моід
minMaskA = padarray(minMask, [KernelSize, KernelSize], 'symmetric', 'both');

for i =KernelSize+1 : KernelSize+row
    for j = KernelSize+1 : KernelSize+col
       min_num = minMask((i-KernelSize):(i+KernelSize), (j-KernelSize):(j+KernelSize));
       min_numA = min(min(min_num));
       minMaskA(i,j) = min_numA;
    end
end

