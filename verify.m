function [result] = verify(n, q, h, f, Lpk, miu, C, z1, z2, theta, t0, h0)

N = size(Lpk,1);
    % Compute di = d0 + i·θ, for all i∈[N].
    % Note that all di are stored in an N × (n × d) dimensional matrix.

for i = 1:N
   ti(i,1:n) = mod(t0 + i*theta, q);
end

% Compute R0 = z1 + z2*h - c·Σpk
z2h = zeros(1,2*n-1);
cpk = zeros(1,2*n-1);
sum1 = zeros(1,2*n-1);

for j = 1:1
    z2h(j,:) = z2h(j,:) + conv(z2(j,:), h(j,:));
for k = 1:N
    cpk(1,:) = cpk(1,:) + conv(C(k,:), Lpk(k,:));
end
sum1(j,:) = sum1(j,:) + z2h(j,:) - cpk(j,:);
[Q6, R6] = deconv(sum1(1,:), f);
end

R6 = mod(R6(1,n:2*n-1),q);
R0_k = mod((z1 + R6), q);


% Compute R1 = z1 + z2*h0 - c·Σti
z2h0 = zeros(1,2*n-1);
cti = zeros(1,2*n-1);
sum2 = zeros(1,2*n-1);

for j = 1:1
    z2h0(j,:) = z2h0(j,:) + conv(z2(j,:), h0(j,:));
for k = 1:N
    cti(1,:) = cti(1,:) + conv(C(k,:), ti(k,:));
end
sum2(j,:) = sum2(j,:) + z2h0(j,:) - cti(j,:);
[Q7, R7] = deconv(sum2(j,:), f);
end

R7 = mod(R7(1,n:2*n-1),q);
R1_k = mod((z1 + R7), q);


 % Compute c = Σci, for all i∈[N].
    % All ci are stored in matrix C.
    c_zero = zeros(1,1);
    for k=1:N
        c_zero = c_zero + C(k,:);
    end                         
    % Make c and all ci in the same group of additive mod 3.
    % They are all in the same challenge space Dc.
    c = mod(c_zero,3);
    for i=1:n
        if(c(1,i) == 2)
            c(1,i) = -1;
        end
    end


miu_h = [double(miu), zeros(1,1*n-length(double(miu)))];
Verify_c = hash ([Lpk; miu_h; R0_k; R1_k; theta],'SHA-512');
Verify_c = [Verify_c,Verify_c,Verify_c,Verify_c,Verify_c,Verify_c,Verify_c,Verify_c];


hash_c = [];
    for i=1:strlength(Verify_c)
        hash_c(1,i) = mod(Verify_c(1,i),3);
        if(hash_c(1,i) == 2)
            hash_c(1,i) = -1;
        end
    end

for i=1:1024
            if(z1(1,1024) > 520430 && z1(1,1024) < -520430)
                break
            end
            if(z2(1,1024) > 520430 && z2(1,1024) < -520430)
                break
            end
end

     if (all(c == hash_c))
        result = 1;
    else
        result = 0;
    end


end