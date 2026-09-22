t=-10:0.01:10;
yt=rectpuls(t,4);
plot(t,yt),grid on;
axis([-10,10,-0.2,1.2]);
title('y(t)=rectpuls(t,4)');