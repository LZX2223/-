p=0.01;
t1=0:p:1;x1=ones(size(t1));
t2=0:p:2;x2=ones(size(t2));
y=conv(x1,x2);
y=y*p;
t0=t1(1)+t2(1);
t3=length(x1)+length(x2)-2;
t=t0:p:(t3*p+t0);
subplot(2,2,1)
plot(t1,x1),grid on;
title('x1(t)')
subplot(2,2,2)
plot(t2,x2),grid on;
title('x2(t)')
subplot(2,2,3)
plot(t,y),grid on;
axis([-0,3,0,1.2]);
g=get(gca,'position');
g(3)=2.5*g(3);
set(gca,'position',g)
title('y(t)=x1(t)*x2(t)')