function[Endu2]=Endurance_deviation(W0,W1,h,v)
[Endu,v1]=Endurance_best(W0,W1,h)
x=v/v1;
Endu2=Endu*4*x/(x^4+3);