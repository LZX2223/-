a=[1 2 1];
b=[1 1 1];
t=0:0.001:6;
f=cos(t).*heaviside(t);
lsim(b,a,f,t);