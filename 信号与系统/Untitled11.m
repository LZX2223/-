t=-10:0.001:10;
yt=t.*sin(5*pi*t).*heaviside(t);
plot(t,yt),grid on;
axis([-3,10,-10,10]);
title('y2(t)=tsin5Πt*u(t)');