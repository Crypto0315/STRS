function [C, z1, z2, theta, t0, h0] = signature(n, q, h, f, Lpk, miu, s1, s2)

N = size(Lpk,1);
%N = 5;

%Lpk = [PK;randi([-q,q], N-1, n)];

%   Compute t0 = H2(T,M), h0 = H2(T)
    %   To get the image in the specified range, we use the random function
    %   instead of the H2 hash function.


%   Compute t0 = H2(T,M), h0 = H2(T)
%   To get the image in the specified range, we use the random function
%   instead of the H2 hash function.
t0 = randi([-q,q], 1, n);
h0 = randi([-q,q], 1, n);

%  Compute tπ = s1 + s2*h0.
[Q1, R1] = deconv(conv(s2, h0), f);
s2h0 = mod(R1(1,n:2*n-1),q);
tpai = mod(s1 + s2h0, q);

%  Compute tag
theta = mod ((tpai - t0)*1,q);

%  Compute the rest of ti,i∈[N]\{π}.
     for i = 2:N
        ti(i,1:n)= mod (t0 + i*theta, q);
     end

% 随机选取多项式y1 y2
y1 = randi([-11500,11500], 1, n);
y2 = randi([-11500,11500], 1, n);


% For i∈[N]\{π}, store ci into a (N-1) × n dimensional matrix C.
C = randi([-1,1], N-1, n);


% Compute R0 = y1 + y2*h - c·Σpk
cpk = zeros(1,2*n-1);
y2h = zeros(1,2*n-1);
sum1 = zeros(1,2*n-1);

for j = 1:1
    y2h(j,:) = y2h(j,:) + conv(y2(j,:), h(j,:));
for k = 1:N-1
    cpk(1,:) = cpk(1,:) + conv(C(k,:), Lpk(k+1,:));
end
sum1(j,:) = sum1(j,:) + y2h(j,:) - cpk(j,:);
[Q2, R2] = deconv(sum1(j,:), f);
end

R2 = mod(R2(1,n:2*n-1),q);
R0_k = mod((y1 + R2), q);


% Compute R1 = y1 + y2*h0 - c·Σt
y2h0 = zeros(1,2*n-1);
cti = zeros(1,2*n-1);
sum2 = zeros(1,2*n-1);


for j = 1:1
    y2h0(j,:) = y2h0(j,:) + conv(y2(j,:), h0(j,:));
for k = 1:N-1
    cti(1,:) = cti(1,:) + conv(C(k,:), ti(k+1,:));
end
sum2(j,:) = sum2(j,:) + y2h0(j,:) - cti(j,:);
[Q3, R3] = deconv(sum2(j,:), f);
end

R3 = mod(R3(1,n:2*n-1),q);
R1_k = mod((y1 + R3), q);


%为了方便测试，假设消息为hello
miu_h = [double(miu), zeros(1,1*n-length(double(miu)))];

cc = hash ([Lpk; miu_h; R0_k; R1_k; theta],'SHA-512');
cc = [cc,cc,cc,cc,cc,cc,cc,cc];

c = [];
for i=1:strlength(cc)
    c(1,i) = mod(cc(1,i),3);
    if(c(1,i) == 2)
       c(1,i) = -1;
    end
end


% Compute cπ = c - Σci, i∈[N]\{π}.
c_ = zeros(1,1);
for k=1:N-1
    c_ = c_ + C(k,:);
end

% Make cpai and other ci in the same group of additive mod 3.
cpai = mod(c-c_,3);
for i=1:n
    if(cpai(1,i) == 2)
       cpai(1,i) = -1;
    end
end
 
% Splice cpai and C to form a new C, and store it in
% a N*n-dimensional matrix.
C = [cpai;C];

% Compute z1, z2
[Q4, R4] = deconv(conv(cpai, s1), f);
cs1 = mod(R4(1,n:2*n-1),q);
z1 = mod(y1 + cs1, q);


[Q5, R5] = deconv(conv(cpai, s2), f);
cs2 = mod(R5(1,n:2*n-1),q);
z2 = mod(y2 + cs2, q);

 for i=1:1024
            if(z1(1,1024) > 520430 && z1(1,1024) < -520430)
                break
            end
            if(z2(1,1024) > 520430 && z2(1,1024) < -520430)
                break
            end
 end


end







