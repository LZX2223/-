n=(-10:10);
a=[1,-0.5];
b=1;
x=sin(n*pi/4).*heaviside(n);
y=filter(b,a,x);
stem(n,y);
title('输出序列')