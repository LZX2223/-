n=-10:10;
a=0.9;
yn=a.^n;
stem(n,yn),grid on;
axis([-10,10,0,3]);
title('y(n)=(0.9)n(−10≤n≤10)')