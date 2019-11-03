function [output]=select(x)
[x_r,x_c]=size(x);
y=zeros(x_r,x_c);
u=x(1:64,1:64);
%将x中与63相近的值都变成63
for i=1:x_r
    for j=1:x_c
        if (abs(x(i,j)-63)<=2)
            x(i,j)=63;
        end
    end
end
y=x;
%保持低频系数不变
y(1:64,1:64)=u;
output=y;