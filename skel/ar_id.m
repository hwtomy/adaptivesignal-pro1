function [Ahat, sigma2hat] = ar_id(y, N)

% [Ahat,sigma2hat]=ar_id(y,N)
%
%	y			- Data sequence
%	N			- Model order 
%	Ahat			- Estimate of AR polynomial [1, a1, ..., aN]
%	sigma2hat		- Estimate of noise variance 
%
%
%  ar_id: Identification of AR model
%
%         Model: y(n)+a_{1}y(n-1)+...+a_{N}y(n-N)=e(n)
%
%     
%     Author: 
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sigmayy_hat = covhat(y,N);
sigmayx_hat = xcovhat(y(2:end),y,N);

[xhat,thetahat] = firw(y,sigmayx_hat, sigmayy_hat);

Ahat = [1, -columnVector(thetahat)'];


xhat = xhat(N:end); 
y = y(N+1:end);
finalLen = min(length(xhat), length(y));
sigma2hat = sum((y(1:finalLen) - xhat(1:finalLen)).^2)/finalLen;