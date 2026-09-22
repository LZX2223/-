n=-10:10;
A=1i*pi*n/3;
yn=exp(A);
zn=real(yn);
stem(n,zn),grid on;
axis([-10,10,-2,2]);
title('y(n)=eiΠn/3(−10≤n≤10)的实部')