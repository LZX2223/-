clc; % 清空命令行窗口
clear; % 清除工作区中的所有变量
close all; % 关闭所有已经打开的图形窗口

T = 1; % 设置采样间隔 T = 1 s
Fs = 1 / T; % 根据采样间隔计算采样频率 Fs
wp = 0.2 * pi; % 设置数字通带截止频率 wp = 0.2π rad/sample
ws = 0.3 * pi; % 设置数字阻带截止频率 ws = 0.3π rad/sample
Rp = 1; % 设置通带最大衰减 Rp = 1 dB
As = 15; % 设置阻带最小衰减 As = 15 dB

Omegap = 2 / T * tan(wp / 2); % 利用双线性变换预畸变公式计算模拟通带截止频率
Omegas = 2 / T * tan(ws / 2); % 利用双线性变换预畸变公式计算模拟阻带截止频率
lambda_sp = Omegas / Omegap; % 计算阻带频率与通带频率之比
k_sp = sqrt((10^(0.1 * Rp) - 1) / (10^(0.1 * As) - 1)); % 根据通带和阻带衰减计算参数 k_sp
N_real = -log10(k_sp) / log10(lambda_sp); % 根据 Butterworth 滤波器阶数公式计算理论阶数
N = ceil(N_real); % 将理论阶数向上取整得到实际阶数
Omegac = Omegas / ((10^(0.1 * As) - 1)^(1 / (2 * N))); % 用阻带指标计算模拟 3dB 截止频率

k = 1:N; % 设置极点编号 k = 1,2,...,N
theta = pi / 2 + (2 * k - 1) * pi / (2 * N); % 计算 Butterworth 极点在左半平面的角度
pk = Omegac * exp(1j * theta); % 根据极点角度和截止频率计算模拟滤波器极点
d = real(poly(pk)); % 由极点构造模拟滤波器分母多项式系数
c = Omegac^N; % 构造模拟滤波器分子多项式系数，使直流增益为 1

[b, a] = bilinear(c, d, Fs); % 调用双线性变换函数，将模拟滤波器转换为数字滤波器
[H, w] = freqz(b, a, 1024); % 计算自编方法得到的数字滤波器频率响应
mag = abs(H); % 计算自编方法得到的幅度响应
mag_dB = 20 * log10(mag); % 将自编方法得到的幅度响应转换为 dB 形式
phase = angle(H); % 计算自编方法得到的相位响应
phase_unwrap = unwrap(phase); % 对自编方法得到的相位响应进行解卷绕处理

fprintf('Butterworth数字低通滤波器设计结果如下：\n'); % 输出设计结果标题
fprintf('数字通带截止频率 wp = %.4fπ rad/sample\n', wp / pi); % 输出数字通带截止频率
fprintf('数字阻带截止频率 ws = %.4fπ rad/sample\n', ws / pi); % 输出数字阻带截止频率
fprintf('模拟通带截止频率 Omegap = %.4f rad/s\n', Omegap); % 输出模拟通带截止频率
fprintf('模拟阻带截止频率 Omegas = %.4f rad/s\n', Omegas); % 输出模拟阻带截止频率
fprintf('lambda_sp = %.4f\n', lambda_sp); % 输出频率比 lambda_sp
fprintf('k_sp = %.4f\n', k_sp); % 输出参数 k_sp
fprintf('理论阶数 N_real = %.4f\n', N_real); % 输出理论阶数
fprintf('实际阶数 N = %d\n', N); % 输出实际滤波器阶数
fprintf('模拟截止频率 Omegac = %.4f rad/s\n', Omegac); % 输出模拟 3dB 截止频率

disp('模拟滤波器极点 pk = '); % 输出极点提示信息
disp(pk.'); % 显示模拟滤波器极点
disp('模拟滤波器分子多项式系数 c = '); % 输出模拟滤波器分子系数提示信息
disp(c); % 显示模拟滤波器分子多项式系数
disp('模拟滤波器分母多项式系数 d = '); % 输出模拟滤波器分母系数提示信息
disp(d); % 显示模拟滤波器分母多项式系数
disp('自编方法数字滤波器分子多项式系数 b = '); % 输出自编方法数字滤波器分子系数提示信息
disp(b); % 显示自编方法数字滤波器分子多项式系数
disp('自编方法数字滤波器分母多项式系数 a = '); % 输出自编方法数字滤波器分母系数提示信息
disp(a); % 显示自编方法数字滤波器分母多项式系数

figure; % 新建图形窗口，用于绘制自编方法的三个频率响应图
subplot(3,1,1); % 创建三行一列的第一个子图
plot(w / pi, mag, 'LineWidth', 1.5); % 绘制自编方法的幅度响应曲线
grid on; % 打开网格
ylabel('幅度'); % 设置纵坐标标签为幅度
title('自编极点法+双线性变换法频率响应'); % 设置图形标题

subplot(3,1,2); % 创建三行一列的第二个子图
plot(w / pi, mag_dB, 'LineWidth', 1.5); % 绘制自编方法的幅频响应 dB 曲线
grid on; % 打开网格
ylabel('增益/dB'); % 设置纵坐标标签为增益 dB

subplot(3,1,3); % 创建三行一列的第三个子图
plot(w / pi, phase_unwrap, 'LineWidth', 1.5); % 绘制自编方法的相位响应曲线
grid on; % 打开网格
xlabel('\omega / \pi'); % 设置横坐标标签为归一化数字频率
ylabel('相位/rad'); % 设置纵坐标标签为相位

wc = 2 / pi * atan(Omegac * T / 2); % 将模拟截止频率转换为 MATLAB butter 函数所需的归一化数字截止频率
[b2, a2] = butter(N, wc); % 调用 MATLAB 内置 butter 函数进行设计验证
[H2, w2] = freqz(b2, a2, 1024); % 计算内置 butter 函数得到的数字滤波器频率响应
mag2 = abs(H2); % 计算内置 butter 函数得到的幅度响应
mag2_dB = 20 * log10(mag2); % 将内置 butter 函数得到的幅度响应转换为 dB 形式
phase2 = angle(H2); % 计算内置 butter 函数得到的相位响应
phase2_unwrap = unwrap(phase2); % 对内置 butter 函数得到的相位响应进行解卷绕处理

figure; % 新建图形窗口，用于绘制内置 butter 函数的三个频率响应图
subplot(3,1,1); % 创建三行一列的第一个子图
plot(w2 / pi, mag2, 'LineWidth', 1.5); % 绘制内置 butter 函数的幅度响应曲线
grid on; % 打开网格
ylabel('幅度'); % 设置纵坐标标签为幅度
title('MATLAB内置butter函数频率响应'); % 设置图形标题

subplot(3,1,2); % 创建三行一列的第二个子图
plot(w2 / pi, mag2_dB, 'LineWidth', 1.5); % 绘制内置 butter 函数的幅频响应 dB 曲线
grid on; % 打开网格
ylabel('增益/dB'); % 设置纵坐标标签为增益 dB

subplot(3,1,3); % 创建三行一列的第三个子图
plot(w2 / pi, phase2_unwrap, 'LineWidth', 1.5); % 绘制内置 butter 函数的相位响应曲线
grid on; % 打开网格
xlabel('\omega / \pi'); % 设置横坐标标签为归一化数字频率
ylabel('相位/rad'); % 设置纵坐标标签为相位

disp('MATLAB内置butter函数设计的数字滤波器分子系数 b2 = '); % 输出内置函数分子系数提示信息
disp(b2); % 显示内置函数设计得到的分子系数
disp('MATLAB内置butter函数设计的数字滤波器分母系数 a2 = '); % 输出内置函数分母系数提示信息
disp(a2); % 显示内置函数设计得到的分母系数