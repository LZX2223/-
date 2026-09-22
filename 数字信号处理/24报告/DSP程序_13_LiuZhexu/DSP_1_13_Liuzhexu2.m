%% ==================== 实验内容2：连续时间信号理想抽样 ====================
clear; clc; close all;

%%  绘制连续时间信号 x(t) 的波形
% x(t) = 5cos(Ω1 t) - 3cos(Ω2 t) + 2cos(Ω3 t) + cos(Ω4 t)
% Ω1=2π, Ω2=3π, Ω3=6π, Ω4=8π  → 对应频率 1Hz, 1.5Hz, 3Hz, 4Hz
Omega1 = 2*pi;
Omega2 = 3*pi;
Omega3 = 6*pi;
Omega4 = 8*pi;

t = 0:0.01:5;  % 时间范围0~5s（
xt = 5*cos(Omega1*t) - 3*cos(Omega2*t) + 2*cos(Omega3*t) + cos(Omega4*t);

figure('Name', '连续时间信号 x(t)');
plot(t, xt, 'LineWidth', 1.5);  % 使用plot绘制连续曲线
title('连续时间信号 x(t)');
xlabel('t (秒)'); ylabel('幅度');
grid on;
axis tight;

%% 绘制 fs=12Hz 和 fs=20Hz 的抽样序列（用stem显示离散点）
% 抽样原理：x[n] = x(n Ts), Ts=1/fs

% ------------------- fs = 12 Hz -------------------
fs1 = 12;
Ts1 = 1/fs1;
t_sample1 = 0:Ts1:5;                    % 采样时刻
x_sample1 = 5*cos(Omega1*t_sample1) - 3*cos(Omega2*t_sample1) ...
          + 2*cos(Omega3*t_sample1) + cos(Omega4*t_sample1);

figure('Name', 'fs=12Hz 抽样序列');
stem(t_sample1, x_sample1, 'filled', 'LineWidth', 1.2);
title('抽样序列（fs = 12 Hz）');
xlabel('t (秒)'); ylabel('x[n]');
grid on;

% ------------------- fs = 20 Hz -------------------
fs2 = 20;
Ts2 = 1/fs2;
t_sample2 = 0:Ts2:5;
x_sample2 = 5*cos(Omega1*t_sample2) - 3*cos(Omega2*t_sample2) ...
          + 2*cos(Omega3*t_sample2) + cos(Omega4*t_sample2);

figure('Name', 'fs=20Hz 抽样序列');
stem(t_sample2, x_sample2, 'filled', 'LineWidth', 1.2);
title('抽样序列（fs = 20 Hz）');
xlabel('t (秒)'); ylabel('x[n]');
grid on;

