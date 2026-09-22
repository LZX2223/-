a=[1,4,6,4,1];
b=[1,3,7];
t=0:0.01:6;
f=heaviside(t);
lsim(b,a,f,t);
xlabel('Time'),ylabel('g(t)')
title('阶跃响应')