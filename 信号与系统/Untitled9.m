t=-20:0.01:20;
yt=sawtooth(t,0.5);
plot(t,yt),grid on;
axis([-20,20,-2,2]);
title('y(t)=sawtooth(t,0.5)')