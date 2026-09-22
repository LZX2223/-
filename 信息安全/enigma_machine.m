function enigma_machine()
    % 定义转子和反射器
    rotor1 = 'EKMFLGDQVZNTOWYHXUSPAIBRCJ'; % I
    rotor2 = 'AJDKSIRUXBLHWTMCQGZNPYFVOE'; % II
    rotor3 = 'BDFHJLCPRTXVZNYEIWGAKMUSQO'; % III
    reflector = 'YRUHQSLDPXNGOKMIEBFZCWVJAT'; % Reflector B

    plaintext = input('请输入明文（仅限大写字母）：', 's');
    plaintext = upper(plaintext); % 转换为大写
    
    % 设置转子初始位置（环设置），均为'A'
    rotor1_pos = 1; % A
    rotor2_pos = 1; % A
    rotor3_pos = 1; % A

    % 加密（修正后：先加密，后步进，保证逻辑一致性）
    ciphertext = '';
    for i = 1:length(plaintext)
        char_index = plaintext(i) - 'A' + 1; 

        % 先加密（当前转子状态）
        char_index = rotor_pass(char_index, rotor1, rotor1_pos);
        char_index = rotor_pass(char_index, rotor2, rotor2_pos);
        char_index = rotor_pass(char_index, rotor3, rotor3_pos);

        char_index = reflector(char_index) - 'A' + 1;

        char_index = reverse_rotor_pass(char_index, rotor3, rotor3_pos);
        char_index = reverse_rotor_pass(char_index, rotor2, rotor2_pos);
        char_index = reverse_rotor_pass(char_index, rotor1, rotor1_pos);

        ciphertext = [ciphertext, char(char_index + 'A' - 1)];

        % 后步进（为下一个字符准备）
        rotor1_pos = mod(rotor1_pos, 26) + 1;
        if rotor1_pos == 1
            rotor2_pos = mod(rotor2_pos, 26) + 1;
            if rotor2_pos == 1
                rotor3_pos = mod(rotor3_pos, 26) + 1;
            end
        end
    end

    % 解密（与加密逻辑完全一致，仅输入为密文）
    decryptedtext = '';
    rotor1_pos = 1; % 重置初始位置
    rotor2_pos = 1;
    rotor3_pos = 1;
    for i = 1:length(ciphertext)
        char_index = ciphertext(i) - 'A' + 1;

        % 先解密（当前转子状态）
        char_index = rotor_pass(char_index, rotor1, rotor1_pos);
        char_index = rotor_pass(char_index, rotor2, rotor2_pos);
        char_index = rotor_pass(char_index, rotor3, rotor3_pos);
        char_index = reflector(char_index) - 'A' + 1;
        char_index = reverse_rotor_pass(char_index, rotor3, rotor3_pos);
        char_index = reverse_rotor_pass(char_index, rotor2, rotor2_pos);
        char_index = reverse_rotor_pass(char_index, rotor1, rotor1_pos);
        
        decryptedtext = [decryptedtext, char(char_index + 'A' - 1)];

        % 后步进（与加密时的步进规则一致）
        rotor1_pos = mod(rotor1_pos, 26) + 1;
        if rotor1_pos == 1
            rotor2_pos = mod(rotor2_pos, 26) + 1;
            if rotor2_pos == 1
                rotor3_pos = mod(rotor3_pos, 26) + 1;
            end
        end
    end

    % 输出结果
    disp(['密文: ', ciphertext]);
    disp(['解密后: ', decryptedtext]);
end

% 转子正向传递（保持不变）
function output = rotor_pass(input, rotor, rotor_pos)
    output = rotor(mod(input + rotor_pos - 2, 26) + 1) - 'A' + 1;
end

% 转子反向传递（修复核心：用数学遍历替代circshift）
function output = reverse_rotor_pass(input, rotor, rotor_pos)
    target_char = char(input + 'A' - 1);
    for x = 1:26
        shifted_x = mod(x + rotor_pos - 2, 26) + 1; % 正向映射的索引计算
        if rotor(shifted_x) == target_char
            output = x;
            return;
        end
    end
    output = -1; % 异常处理
end