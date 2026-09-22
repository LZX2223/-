%% ==================== 实验内容1：生成5种常见离散信号 ====================
clear; clc; close all;

N = input('请输入离散信号长度 N : ');  % 用户输入长度
n = 0:N-1;  % 时间索引 n = 0,1,2,...,N-1

%% 1. 单位抽样序列 δ(n)
% 公式：δ(n) = 1 (n=0), 0 (n≠0)
% MATLAB实现：先全零，再把n=0位置设为1
delta = zeros(1, N);   % 创建全零向量
delta(1) = 1;          % n=0处赋值为1

figure('Name', '单位抽样序列 δ(n)');
stem(n, delta, 'filled');  % 使用stem绘制离散信号（带实心圆点）
title('单位抽样序列 δ(n)');
xlabel('n'); ylabel('幅度');
grid on;


%% 2. 单位阶跃序列 u(n)
% 公式：u(n) = 1 (n≥0), 0 (n<0)
% MATLAB实现：直接用ones函数（本实验n从0开始）
u = ones(1, N);   % 全1向量

figure('Name', '单位阶跃序列 u(n)');
stem(n, u, 'filled');
title('单位阶跃序列 u(n)');
xlabel('n'); ylabel('幅度');
grid on;

%% 3. 正弦序列 x(n) = A sin(2π f n / Fs + φ)
% 参数可自行修改（此处示例：A=1, f=50Hz, Fs=1000Hz, φ=0）
% 数字频率 f/Fs = 0.05，可看到清晰正弦波形
A = 1;
f = 50;      % 频率（Hz）
Fs = 1000;   % 采样频率（Hz）
phi = 0;     % 初始相位（弧度）

x_sin = A * sin(2*pi * f * n / Fs + phi);

figure('Name', '正弦序列');
stem(n, x_sin, 'filled');
title('正弦序列 x(n) = A sin(2π f n / Fs + φ)');
xlabel('n'); ylabel('幅度');
grid on;
% 修改建议：改变f/Fs可控制一个周期内的采样点数

%% 4. 复正弦序列 x(n) = e^{j ω n}
% 参数示例：ω = π/8（数字角频率）
% 由于是复数，绘图时分别画实部和虚部（教材常这样对比）
w = pi/8;                 % 数字角频率（可修改）
x_complex = exp(1j * w * n);  % 复指数信号

figure('Name', '复正弦序列');
subplot(2,1,1);           % 实部
stem(n, real(x_complex), 'filled');
title('复正弦序列 - 实部 Re[e^{j ω n}]');
xlabel('n'); ylabel('实部'); grid on;

subplot(2,1,2);           % 虚部
stem(n, imag(x_complex), 'filled');
title('复正弦序列 - 虚部 Im[e^{j ω n}]');
xlabel('n'); ylabel('虚部'); grid on;

%% 5. 指数序列 x(n) = a^n
% 参数示例：a=0.8（|a|<1，衰减序列）；也可设a=1.2（增长）或a=-0.9（振荡衰减）
a = 0.5;
x_exp = a .^ n;   % 点乘幂运算（向量形式）

figure('Name', '指数序列');
stem(n, x_exp, 'filled');
title('指数序列 x(n) = a^n （a=0.5）');
xlabel('n'); ylabel('幅度');
grid on;
