function SigmaYxhat = xcovhat(x, y, N)

%
% SigmaYxhat = xcovhat(x, y, N)
%
%	y, x			- Data sequences
%	N			- Size of covariance matrix
%
%  xcovhat: Estimates SigmaYx=E[Y(n)x(n)]
%
%		where 
%
%	   	Y(n)=[y(n) y(n-1) ... y(n-N+1)]^{T}
%
%     
%     Author: 
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L = length(y);
M = length(x);

M = min(L,M);
r_xy = zeros(N,1);
for k = 1 : N
    r_xy(k) = sum(y(1:M-k+1) .* x(k : M))/M;
end
SigmaYxhat = r_xy;