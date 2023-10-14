clc; clear;

%执行系统建立算法
[n, q, h, f] = setup;


%执行密钥生成算法1000次
tic;
for p = 1:1
    [s1, s2, PK] = keygen(n, q, h, f);
end
fprintf('The computational overhead of KeyGen(PP) Algorithm running 1000 times is %f sec.\n',toc);
toc;
                 
%签名者输入环大小 
N = input("Please enter the size of the ring:");

%令签名者索引π为1,对于其他成员的公钥，可以通过在某个特定集合中随机抽样获得它们
Lpk = [PK;randi([-q,q], N-1, n)];
%输入消息μ，μ不是matlab中的合法变量，因此我们使用miu表示μ
prompt = 'Please enter the message you need to sign(e.g. Hello World！): ';
miu = input(prompt, 's');

tic;
% Timing tool: Start.
for p=1:1
   [C, z1, z2, theta, t0, h0] = signature(n, q, h, f, Lpk, miu, s1, s2);
end
% Timing tool: End.
fprintf('The computational overhead of Sign Algorithm running 1000 times is %f sec.\n',toc);

tic; 
% Timing tool: Start.
for v =1:1
    [result] = verify(n, q, h, f, Lpk, miu, C, z1, z2, theta, t0, h0);
end
% Print verification result.
if (result)
    fprintf ('Ring signature is valid! Output 1\n' );
else
    fprintf ('Ring signature is invalid! Output 0\n' );
end
fprintf('The computational overhead of Verify Algorithm running 1000 times is %f sec.\n',toc);
% toc;
% Timing tool: End.
fprintf("\n");