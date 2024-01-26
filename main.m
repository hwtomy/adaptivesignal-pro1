[z, fs] = audioread('EQ2401project1data2024.wav');
% soundsc(z,fs);
figure;
plot(periodogram(z,hanning(length(z)), fs));
hold on
thre = 0.18;
N=length(z);
K = 20;
L= round(N/K);
ord = 9;%(under 8 )
silent=find(abs(z)< thre);
noisees = z(silent);
% nmean= mean(noisees);
varnoise = var(noisees);
noise_ar = aryule(noisees, ord);
v= randn(1,L);
v= filter(1, noise_ar, v);
cvar = var(v);
v= v*sqrt(varnoise/cvar);
xfir=[];
% h = fir1(55,0.06);
% v=filter(v,1,h);

% for i =1:K
%     y = z(L*(i-1)+1:L*i);
%     sigY = xcovhat(y,y,L);
%     sigV = xcovhat(v,v,L);
%     sigYX = sigY - sigV;
%     sigYY = covhat(y, L);
%     [xhat, theta] = firw(y,sigYX,sigYY);
%     xfir = [xfir,transpose(xhat)];
% end
% pause(3);
% soundsc(xfir,fs);
% plot(periodogram(xfir,hanning(length(xfir)), fs));
% legend('Before','After');
% figure;
% plot(z);
% hold on
% plot(xfir);
% legend('Before','After');


Nlen =13; %(6,8,10,  12,13,14)
center_freq = 2230;  %(2238-2272)
bandwidth =10; %find by 5Hz
normalized_freq = [center_freq - bandwidth/2, center_freq + bandwidth/2] / (fs/2);
sf = fir1(100, normalized_freq, 'bandpass');
window = hamming(101);
sf = sf .* window';
zf = filter(sf, 1, z);


% center_freq = 2600;  
% bandwidth =60 ;  
% normalized_freq = [center_freq - bandwidth/2, center_freq + bandwidth/2] / (fs/2);
% wn = [fl,fh]/(fs/2);
% zf = fir1(fo, wn, 'bandpass');

[Ahat, sigma2hat] = aryule(zf, Nlen);
% sound=find(abs(z)> 0.2);
% xs = z(sound);
% v1= sqrt(varnoise)*rand(length(xs),1);
% v1= filter(1, noise_ar, v1);
% xh = xs-v1;
% Nlen = 7;
% [Ahat, sigma2hat] = aryule(xs, Nlen);

[PhixyNum,PhixyDen,PhiyyNum,PhiyyDen] = spec_add(Ahat, sigma2hat, noise_ar, varnoise);

% [xhatnc, numnc, dennc] = ncw(z, PhixyNum, PhixyDen, PhiyyNum, PhiyyDen);
% % pause(10);
% soundsc(xhatnc,fs);
% plot(periodogram(xhatnc,hanning(length(xfir)), fs));
% legend('Before','After');

[xhatc, numnc, dennc] = cw(z, PhixyNum, PhixyDen, PhiyyNum, PhiyyDen,0);
% pause(10);
soundsc(xhatc,fs);
plot(periodogram(xhatc,hanning(length(xhatc)), fs));
hold on
legend('Before','After');













