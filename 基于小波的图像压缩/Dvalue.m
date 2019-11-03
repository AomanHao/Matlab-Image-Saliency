function [y]=Dvalue(x)
[x_r,x_c]=size(x);
z=zeros(x_r,x_c);
for i=1:x_r
    if (i==1)
        z(i,1:x_c)=x(i,1:x_c);
    else
        z(i,1:x_c)=x(i-1,1:x_c)-x(i,1:x_c);
    end
end
for i=1:x_r
    for j=1:x_c
        if (abs(z(i,j))<=0)
            z(i,j)=0;
        end
    end
end
y=z;