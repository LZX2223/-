t=0:0.01:6;
sys=tf([1,3,7],[1,4,6,4,1]);
g=step(sys,t);
plot(t,g),grid on;
title('阶跃响应')