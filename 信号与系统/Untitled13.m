syms t x;
x=cos(2*t)
subplot(3,1,1),ezplot(x,[-4*pi,4*pi]),grid on;
axis([-4*pi,4*pi,-2,2]);
subplot(3,1,2),y=diff(x,'t',1),ezplot(y,[-4*pi,4*pi]),grid on;
axis([-4*pi,4*pi,-2,2]);
subplot(3,1,3),z=int(x,'t'),ezplot(z,[-4*pi,4*pi]),grid on;
axis([-4*pi,4*pi,-2,2]);

