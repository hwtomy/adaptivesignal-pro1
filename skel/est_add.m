function [xhatnc,xhatc,xhatfir,numnc,dennc,numc,denc,thetahatfir] =...
    est_add(x, v, N, Ahat, sigma2hat, Anoisehat,...
    sigma2noisehat,SigmaYxhat, SigmaYYhat)

%
% [xhatnc,xhatc,xhatfir,numnc,dennc,numc,denc,thetahatfir] = 
%     est_add(x, v, N, Ahat, sigma2hat, Anoisehat,
%       sigma2noisehat,SigmaYxhat, SigmaYYhat)
%	
%	x			 - AR Signal
%	v			 - AR Noise, y(n)=x(n)+v(n)
%	N			 - Length of the FIR Wiener filter
%	Ahat,sigma2hat 		 - Estimated or true parameters of x
%	Anoisehat,sigma2noisehat - Estimated or true parameters of v
%	SigmaYxhat		 - E[Y(n) x(n)]
% 	SigmaYYhat		 - E[Y(n) (Y(n))']
%	
% 	xhatnc		- Non-causal Wiener estimate of x
% 	xhatc		- Causal Wiener estimate of x
% 	xhatfir		- FIR Wiener estimate of x
% 	numnc,dennc	- Non-causal Wiener filter
% 	numc,denc	- Causal Wiener filter
% 	thetahatfir	- FIR Wiener filter
%	
%
%  est_add: Estimate using the three different Wiener filters.
%     Plot the 30 first samples of each estimate, x and y.
%     Calculate the MSE of the estimates normalized with the
%     inverse of the noise variance.
%     
%     Author: 
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[xhatfir, thetahatfir] = firw(x+v, SigmaYxhat, SigmaYYhat);

[xhatnc, numnc, dennc] = ncw(x+v, sigma2hat, Ahat, sigma2noisehat*Ahat+sigma2hat*Anoisehat, conv(A,Anoisehat));

[xhatc, numc, denc] = cw(x+v, sigma2hat, Ahat, sigma2noisehat*Ahat+sigma2hat*Anoisehat, conv(A,Anoisehat));

spec_comp(A,sigma2,Anoise,sigma2noise,numnc,dennc,numc,denc,thetahatfir);

end
