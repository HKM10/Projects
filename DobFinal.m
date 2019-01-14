%Define the variables 
m=400;
Iy=2460;
m1=40;
m2=35.5;
a1=1.011;
a2=1.803;
k1=21000;
k2=21000;
kt1=150000;
kt2=150000;
c1=1500;
c2=1500;
%define new parameters for matrix calculations
o1=-(k1+k2)/m;
o2=(k1*a1-k2*a2)/m;
o3=(k1/m);
o4=(k2/m);
o5=-(c1+c2)/m; 
o6=(c1*a1-c2*a2)/m;
o7=c1/m;
o8=c2/m;
o9=-(a1*k1-a2*k2)/Iy;
o10=-(k1*a1*a1+k2*a2*a2)/Iy;
o11=-(a1*k1)/Iy;
o12=(a2*k2)/Iy;
o13=(a1*c1+a2*c2)/Iy;
o14=-(c1*a1*a1+c2*a2*a2)/Iy;
o15=-(c1*a1)/Iy;
o16=(c2*a2)/Iy;
o17=k1/m1;
o18=-k1*a1/m1;
o19=-(k1+kt1)/m1;
o20=c1/m1;
o21=-(a1*c1)/m1;
o22=-c1/m1;
o23=k2/m2;
o24=k2*a2/m2;
o25=-(k2+kt2)/m2;
o26=c2/m2;
o27=c2*a2/m2;
o28=-c2/m2;
%Define matrix A, Bu, C
A= [0,0,0,0,1,0,0,0;
    0,0,0,0,0,1,0,0;
    0,0,0,0,0,0,1,0;
    0,0,0,0,0,0,0,1;
   o1,o2,o3,o4,o5,o6,o7,o8;
   o9,o10,o11,o12,o13,o24,o15,o16;
   o17,o18,o19,0,o20,o21,o22,0;
   o23,o24,0,o25,o26,o27,0,o28;];
Bu=[0,0,0,0,0,0,kt1/m1,kt2/m2]';
C= [0,1,0,0,0,0,0,0];

lateral=ss(A,Bu,C,0);
G1=tf(lateral);%transfer Function for plant
Gd1=c2d(G1,0.01);%discrete transfer function
%Q
 Num=1;
Den=[1,0];
Q=tf(Num,Den,0.01);
%M
Gd2= (0.081205 *(60.9*z+1)* (z-0.9225) *(z-0.8693)* (z-0.7784)* (z+0.7054)* (z^2 - 1.421*z + 0.7472)*(z-4.288e04))/((z-4.288e04) *(z-1)* (z^2 - 1.932*z + 0.9417) *(z^2 - 1.345*z + 0.6782) *(z^2 - 1.286*z + 0.6538));
Gd3=minreal(Gd2) ;%Cancelling the pole and zero
Gd4=1/Gd3;
MQ=Gd4*Q;
MQ;
%Compensate the system by changing the coefficient for zero of Gd2
%(z+60.9)with (60.2z+1)
MQ=(12.315 *(z-1) *(z^2 - 1.932*z + 0.9417)* (z^2 - 1.345*z + 0.6782)* (z^2 - 1.286*z + 0.6538))/((z* (z*60.9+1) *(z-0.9225)* (z-0.8693)* (z-0.7784)* (z+0.7054)* (z^2 - 1.421*z + 0.7472)));
%Supply Gd3 to plant and disturbance
%Supply MQ to the MQ block

