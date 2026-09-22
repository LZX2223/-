t=-10:0.01:10;
a=-2;
y=exp(a*abs(t));
plot(t,y),grid on;
title(' y(t)=e−2|t|');
