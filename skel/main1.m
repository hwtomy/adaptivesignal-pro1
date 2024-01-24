A=[ ];
Anoise=[];
K=1000;

w=sqrt(sigma2)*randn(N,1);
a1=poly(A);
x=filter(1,a1,w);
e=sqrt(sigma2noise)*randn(N,1);
a2=poly(Anoise);
v=filter(1,a2,e);
y=x+v;
