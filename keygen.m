function[s1, s2, PK] = keygen(n, q, h, f)

% 采样私钥
s1 = randi([-1, 1], 1, n);
s2 = randi([-1, 1], 1, n);

Q = zeros(1, n-1);
R = zeros(1, 2*n-1);

% 计算 pk = s1 + s2 * h
[Q, R] = deconv(conv(s2, h), f);
% s2h = mod(R, q);
s2h = mod(R(1,n:2*n-1),q);

% 计算用户公钥 PK
PK = mod(s1 + s2h, q);


end















