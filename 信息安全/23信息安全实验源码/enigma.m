function enigma_machine()
    % 定义转子和反射器
    rotor1 = 'EKMFLGDQVZNTOWYHXUSPAIBRCJ'; % I
    rotor2 = 'AJDKSIRUXBLHWTMCQGZNPYFVOE'; % II
    rotor3 = 'BDFHJLCPRTXVZNYEIWGAKMUSQO'; % III
    reflector = 'YRUHQSLDPXNGOKMIEBFZCWVJAT'; % Reflector B

    % 输入明文
    plaintext = input('请输入明文（仅限大写字母）：', 's');
    plaintext = upper(plaintext); % 转换为大写

    % 检查输入是否合法
    if ~all(ismember(plaintext, 'A':'Z'))
        error('输入包含非法字符，请仅输入大写字母。');
    end
    
    % 设置转子初始位置（环设置），这里都设置为'A'
    rotor1_pos = 1; % A
    rotor2_pos = 1; % A
    rotor3_pos = 1; % A

    % 加密
    ciphertext = '';
    for i = 1:length(plaintext)
        char_index = plaintext(i) - 'A' + 1; % 将字母转换为数字 (A=1, B=2, ...)

        % 转子转动 (步进)
        rotor1_pos = mod(rotor1_pos, 26) + 1;
        if rotor1_pos == 1
            rotor2_pos = mod(rotor2_pos, 26) + 1;
            if rotor2_pos == 1
                rotor3_pos = mod(rotor3_pos, 26) + 1;
            end
        end

        % 通过转子
        char_index = rotor_pass(char_index, rotor1, rotor1_pos);
        char_index = rotor_pass(char_index, rotor2, rotor2_pos);
        char_index = rotor_pass(char_index, rotor3, rotor3_pos);

        % 通过反射器
        char_index = reflector(char_index) - 'A' + 1;

        % 反向通过转子
        char_index = reverse_rotor_pass(char_index, rotor3, rotor3_pos);
        char_index = reverse_rotor_pass(char_index, rotor2, rotor2_pos);
        char_index = reverse_rotor_pass(char_index, rotor1, rotor1_pos);

        ciphertext = [ciphertext, char(char_index + 'A' - 1)];
    end

    % 解密 (使用相同的设置)
    decryptedtext = '';
        % 重置转子位置！重要！
    rotor1_pos = 1; % A
    rotor2_pos = 1; % A
    rotor3_pos = 1; % A
    for i = 1:length(ciphertext)
        char_index = ciphertext(i) - 'A' + 1;

        % 转子转动 (步进 - 与加密过程完全一致!)
        rotor1_pos = mod(rotor1_pos, 26) + 1;
        if rotor1_pos == 1
            rotor2_pos = mod(rotor2_pos, 26) + 1;
            if rotor2_pos == 1
                rotor3_pos = mod(rotor3_pos, 26) + 1;
            end
        end
        
        %解密过程与加密过程完全一致
        char_index = rotor_pass(char_index, rotor1, rotor1_pos);
        char_index = rotor_pass(char_index, rotor2, rotor2_pos);
        char_index = rotor_pass(char_index, rotor3, rotor3_pos);
        char_index = reflector(char_index) - 'A' + 1;
        char_index = reverse_rotor_pass(char_index, rotor3, rotor3_pos);
        char_index = reverse_rotor_pass(char_index, rotor2, rotor2_pos);
        char_index = reverse_rotor_pass(char_index, rotor1, rotor1_pos);
        
        decryptedtext = [decryptedtext, char(char_index + 'A' - 1)];
    end

    % 输出结果
    disp(['密文: ', ciphertext]);
    disp(['解密后: ', decryptedtext]);
end

% 转子正向传递
function output = rotor_pass(input, rotor, rotor_pos)
    output = rotor(mod(input + rotor_pos - 2, 26) + 1) - 'A' + 1; %包含偏移的转子加密
end

% 转子反向传递
function output = reverse_rotor_pass(input, rotor, rotor_pos)
    shifted_rotor = circshift(rotor,-rotor_pos + 1); % 将转子根据位置旋转
    output = find(shifted_rotor == char(input + 'A' - 1));
end