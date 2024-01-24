function [SigmaYY,SigmaYx] = ...
           firw_cov_add(A, sigma2, Anoise, sigma2noise, N)

%
% [SigmaYY,SigmaYx] = firw_cov_add(A, sigma2, Anoise, sigma2noise, N)
%	
%	A		- AR model for the signal x(n), A(q)x(n)=w(n)
%	sigma2		- E[w(n)*w(n)]
%	Anoise		- AR model for the noise v(n), Anoise(q)v(n)=e(n)
%	sigma2noise	- E[e(n)*e(n)]
%	N  	- Length of Y(n)
%	
% 	SigmaYY		- E[Y(n) (Y(n))']
%	SigmaYx		- E[Y(n) x(n)]
%
%  firw_cov_add: Calculate covariance and cross-covariance for
%     Y(n)=[y(n), y(n-1),...,y(n-N+1)]' where y(n)=x(n)+v(n)
%     
%     Author:
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SigmaYY=toeplitz(ar2cov(A,sigma2,N)+ar2cov(Anoise,sigma2noise,N));
SigmaYx = ar2cov(A,sigma2,N);

end

