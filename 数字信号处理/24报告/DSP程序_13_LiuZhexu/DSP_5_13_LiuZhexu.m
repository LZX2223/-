% 定义系统差分方程的分子系数B（x(n)对应的各项系数）
B = [2, -3, 9, -26, 18];

% 定义系统差分方程的分母系数A（y(n)对应的各项系数）
A = [13, 8, 2, -4, -1];

% 调用自定义级联转换函数，获得所有二阶节系数
[Numerator, Denominator] = cascade_IIR(B, A);

% 在命令窗口显示级联结构的结果
disp('=== 级联结构的二阶节系数 ===');

% 循环打印每一个二阶节的系数,本系统共2个二阶节
for k = 1:size(Numerator, 1)
    fprintf('第 %d 个二阶节:\n', k);
    % 打印分子系数（保留4位小数）
    fprintf('分子系数: [%.4f, %.4f, %.4f]\n', Numerator(k,:));
    % 打印分母系数（保留4位小数）
    fprintf('分母系数: [%.4f, %.4f, %.4f]\n\n', Denominator(k,:));
end

% ====================== 自定义函数定义 ======================
function [Numerator, Denominator] = cascade_IIR(B, A)
% 直接型IIR系统函数转换为级联二阶节形式（完全符合实验要求）
% 输入：B = [b0 b1 ... bN] 分子系数，A = [a0 a1 ... aN] 分母系数
% 输出：Numerator = 每行一个二阶节的分子系数 [b0 b1 b2]
%       Denominator = 每行一个二阶节的分母系数 [1 a1 a2]

% 强制转换为行向量
B = B(:).';
A = A(:).';

% 归一化处理：使分母首项系数为1，同时对分子做相同缩放
if A(1) ~= 1
    B = B / A(1);   % 整体增益归一化
    A = A / A(1);   % 分母首项变为1
end

% 求取零点和极点
zeros_roots = roots(B);      % 分子多项式根（零点）
poles_roots = roots(A);      % 分母多项式根（极点）

% 使用cplxpair按共轭对排序，保证系数为实数
zeros_sorted = cplxpair(zeros_roots);
poles_sorted = cplxpair(poles_roots);

% 计算二阶节数量
num_sections = length(poles_sorted) / 2;

% 初始化系数矩阵
Numerator   = zeros(num_sections, 3);
Denominator = zeros(num_sections, 3);

% 依次生成每个二阶节
for k = 1:num_sections
    % 处理分子零点对
    z_pair = zeros_sorted(2*k-1 : 2*k);
    Numerator(k, :) = poly(z_pair);
    
    % 处理分母极点对
    p_pair = poles_sorted(2*k-1 : 2*k);
    Denominator(k, :) = poly(p_pair);
end
end