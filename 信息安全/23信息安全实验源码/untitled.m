% 参数设置
fs = 1000; % 采样频率
fc = 100; % 截止频率
N = 33; % 滤波器阶数

% 设计FIR低通滤波器
b = fir1(N, fc/(fs/2)); 
% 保存到文本文件
save('filter_coefficients.txt', 'b', '-ascii');


% 生成信号（50Hz正弦波）
t = 0:1/fs:1; % 时间序列
signal = sin(2*pi*5*t); 

% 添加高斯白噪声
noise = 0.1 * randn(size(signal)); 
noisy_signal = signal + noise; 
% 保存到文本文件
save('in.txt', 'noisy_signal', '-ascii');



% 绘制结果
figure;
subplot(3,1,1);
plot(t, signal); 
title('Original Signal');

subplot(3,1,2);
plot(t, noisy_signal); 
title('Noisy Signal');

out = load("D:\download\out.txt");
subplot(3,1,3);
plot(t, [out; 0]);
title('FIF Signal');
