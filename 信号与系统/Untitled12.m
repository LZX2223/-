t=-5:0.01:5;
ft=exp(-t).*sin(10*pi*t)+exp(-t/2).*sin(9*pi*t);
plot(t,ft),grid on;
axis([-5,5,-100,100]);
title('f(t)=e^(-t)*sin( 10πt)+e^(-t/2)*sin( 9πt)')