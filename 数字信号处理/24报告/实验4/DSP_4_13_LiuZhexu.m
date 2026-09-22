% 定义时间序列的n值
n = 0:15; % 定义n的范围0-15

% 生成实验要求的余弦序列
x = cos(5*pi/16 * n); % 生成16点余弦序列 x(n) = cos(5πn/16)

% 计算16点DFT
X_16 = my_dft(x, 16); % 计算16点DFT
mag_X_16 = abs(X_16); % 计算16点DFT的幅度谱

% 计算32点DFT
X_32 = my_dft(x, 32); % 计算32点DFT
mag_X_32 = abs(X_32); % 计算32点DFT的幅度谱

% 计算DTFT
omega = linspace(-pi, pi, 2048); % 生成DTFT频率点
mag_H = abs(my_dtft(x, omega)); % 计算DTFT幅度谱

% 绘制图形
figure;

% 绘制16点DFT幅度谱
subplot(3,1,1);
stem(0:15, mag_X_16, 'filled', 'MarkerSize', 4); % 绘制16点DFT杆图
title('16点DFT幅度谱'); % 设置标题
xlabel('k'); % x轴标签
ylabel('|X(k)|'); % y轴标签
xlim([0 15]); % x轴范围
grid on; % 显示网格

% 绘制32点DFT幅度谱
subplot(3,1,2);
stem(0:31, mag_X_32, 'filled', 'MarkerSize', 4); % 绘制32点DFT杆图
title('32点DFT幅度谱'); % 设置标题
xlabel('k'); % x轴标签
ylabel('|X(k)|'); % y轴标签
xlim([0 31]); % x轴范围
grid on; % 显示网格

% 绘制DTFT幅度谱
subplot(3,1,3);
plot(omega/pi, mag_H); % 绘制DTFT曲线（使用默认颜色）
title('DTFT幅度谱'); % 设置标题
xlabel('归一化频率(\omega/\pi)'); % x轴标签
ylabel('|X(e^{j\omega})|'); % y轴标签
xlim([0 2]); % x轴范围
grid on; % 显示网格

% ====================== 函数定义 ======================

% 自定义DTFT函数
function X = my_dtft(x, omega)
    N = length(x); % 获取序列长度
    X = zeros(size(omega)); % 初始化输出
    for k = 1:length(omega) % 遍历每个频率点
        X(k) = sum(x .* exp(-1j * omega(k) * (0:N-1))); % 计算DTFT
    end
end

% 自定义DFT函数
function X = my_dft(x, N_fft)
    x = x(:); % 转为列向量
    L = length(x); % 获取原始序列长度
    x_padded = [x; zeros(N_fft - L, 1)]; % 补零
    X = zeros(N_fft, 1); % 初始化输出
    for k = 0:N_fft-1 % 遍历每个k值
        X(k+1) = sum(x_padded .* exp(-1j * 2*pi/N_fft * k * (0:N_fft-1)')); % 计算DFT
    end
end