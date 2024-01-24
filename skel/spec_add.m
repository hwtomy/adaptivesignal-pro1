function [PhixyNum,PhixyDen,PhiyyNum,PhiyyDen] = ...
               spec_add(A, sigma2, Anoise, sigma2noise)

%
% [PhixyNum,PhixyDen,PhiyyNum,PhiyyDen] = ...
%                 spec_add(A, sigma2, Anoise, sigma2noise)
%	
%	A		- AR model for the signal x(n), A(q)x(n)=w(n)
%	sigma2		- E[w(n)*w(n)]
%	Anoise		- AR model for the noise v(n), Anoise(q)v(n)=e(n)
%	sigma2noise	- E[e(n)*e(n)]
%	
% 	PhixyNum,PhixyDen	- Cross-spectrum between x(n) and y(n)
% 	PhiyyNum,PhiyyDen	- Spectrum of y(n)
%	
%  spec_add: Calculate spectrum and cross-spectrum for y(n)=x(n)+v(n)
%     
%     
%     Author:
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

phixn = sigma2;
phixd = conv(A, conj(A));
phivn = sigma2;
phivd = conv(Anoise, conj(Anoise));

PhixyNum=phixn;
PhixyDen = phixd;
[PhiyyNum,PhiyyDen] = add(phixn, phixd, phivn, phivd);

end
