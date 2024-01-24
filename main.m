[z, fs] = audioread('EQ2401project1data2024.wav');
soundsc(z,fs);
figure;
plot(periodogram(z,hanning(length(z)), fs));
hold on
thre = 0.18;
N=length(z);
K = 20;
L= round(N/K);
ord = 60;
silent=find(abs(z)< thre);
noisees = z(silent);
nmean= mean(noisees);
varnoise = var(noisees);
noise_ar = aryule(noisees, ord);
v= randn(1,L);
v= filter(1, noise_ar, v);
cvar = var(v);
v= v*sqrt(varnoise/cvar);
xfir=[];
h = fir1(55,0.06);
v=filter(v,1,h);

for i =1:K
    y = z(L*(i-1)+1:L*i);
    sigY = xcovhat(y,y,L);
    sigV = xcovhat(v,v,L);
    sigYX = sigY - sigV;
    sigYY = covhat(y, L);
    [xhat, theta] = firw(y,sigYX,sigYY);
    xfir = [xfir,transpose(xhat)];
end
pause(3);
soundsc(xfir,fs);
plot(periodogram(xfir,hanning(length(xfir)), fs));
legend('Before','After');
figure;
plot(z);
hold on
plot(xfir);
legend('Before','After');






