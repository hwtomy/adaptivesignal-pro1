clc;
clear all;
clc;

[z, fs] = audioread('EQ2401project1data2024.wav');
figure;
plot(periodogram(z,hanning(length(z)), fs));

%% calculate the noise
thre = 0.18;
N=length(z);
K = 20;
L= round(N/K);
ord = 9;
silent=find(abs(z)< thre);
noisees = z(silent);
noiv = var(noisees);
[noise_ar,varnoise] = aryule(noisees, ord);
v= randn(1,L);
v= filter(1, noise_ar, v);
cvar = var(v);
v= v*sqrt(varnoise/noiv);
xfir=[];
% h = fir1(55,0.03);
% v=filter(v,1,h);


%% Fir Wiener filter
for i =1:K
    y = z(L*(i-1)+1:L*i);
    sigY = xcovhat(y,y,L);
    sigV = xcovhat(v,v,L);
    sigYX = sigY - sigV;
    sigYY = covhat(y, L);
    [xhat, theta] = firw(y,sigYX,sigYY);
    xfir = [xfir,transpose(xhat)];
end
%soundsc(xfir,fs);
figure;
plot(periodogram(xfir,hanning(length(xfir)), fs));


%% non_casual filter
Nlen =12; %(6,8,10,  12,13,14)
center_freq = 300;  
bandwidth =20;
normalized_freq = [center_freq - bandwidth/2, center_freq + bandwidth/2] / (fs/2);
sf = fir1(100, normalized_freq, 'bandpass');
 window = hamming(101);
sf = sf .* window';
zf = filter(sf, 1, z);
[Ahat, sigma2hat] = aryule(zf, Nlen);
[PhixyNum,PhixyDen,PhiyyNum,PhiyyDen] = spec_add(Ahat, sigma2hat, noise_ar, varnoise);
[xhatnc, numnc, dennc] = ncw(z, PhixyNum, PhixyDen, PhiyyNum, PhiyyDen);
%soundsc(xhatnc,fs);
figure;
plot(periodogram(xhatnc,hanning(length(xhatnc)), fs));
legend('Before','After');



%% casual wiener filter
Nlen =12; %(6,8,10,  12,13,14)
center_freq = 300;  %(2238-2272)
bandwidth =20; %find by 5Hz
normalized_freq = [center_freq - bandwidth/2, center_freq + bandwidth/2] / (fs/2);
sf = fir1(100, normalized_freq, 'bandpass');
 window = hamming(101);
sf = sf .* window';
zf = filter(sf, 1, z);
[Ahat, sigma2hat] = aryule(zf, Nlen);
[PhixyNum,PhixyDen,PhiyyNum,PhiyyDen] = spec_add(Ahat, sigma2hat, noise_ar, varnoise);
[xhatc, numnc, dennc] = cw(z, PhixyNum, PhixyDen, PhiyyNum, PhiyyDen,0);
soundsc(xhatc,fs);
figure;
plot(periodogram(xhatc,hanning(length(xhatc)), fs));













