function [n, q, h, f] = setup

% 设置公共参数
n = 1024;
q = 2^22;
h = randi([-q,q], 1, n);


% Constructing an irreducible polynomial f = x^d+1.
f = zeros(1, n+1);
f(1,1) = 1;
f(1,n+1) = 1;

end