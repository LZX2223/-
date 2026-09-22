n1 = 0:2;
n2 = 0:3;
n3 = 0:5;
x = [2,1,2];
h = [0,1,2,3];
y = conv( x, h );
subplot( 3,1,1 ); stem( n1,x ); title('signal x');
subplot( 3,1,2 ); stem( n2,h ); title('signal h');
subplot( 3,1,3 ); stem( n3,y ); title('signal y');