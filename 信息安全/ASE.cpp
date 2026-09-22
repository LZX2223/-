#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#pragma warning(disable:4996)  // 禁用VS的4996警告（兼容fgets/scanf等函数）

// --------------------------- 基础常量定义 ---------------------------
// Rcon：密钥扩展时使用的轮常量（AES-128共10轮，对应10个常量）
// 作用：确保每轮扩展的密钥不同，提升安全性
static const unsigned char Rcon[10] = {
    0x01, 0x02, 0x04, 0x08, 0x10,
    0x20, 0x40, 0x80, 0x1b, 0x36
};

// S盒（Substitution Box）：正向替换表（加密时使用）
// 本质：256字节的固定非线性置换，通过仿射变换+有限域求逆生成
// 作用：对单个字节进行替换，引入非线性，抵抗线性攻击
static const unsigned char sbox[256] = {
    0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
    0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
    0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
    0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
    0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
    0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
    0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
    0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
    0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
    0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
    0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
    0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
    0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
    0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
    0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
    0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16
};

// 逆S盒（Contrary Substitution Box）：解密时使用
// 作用：S盒的逆映射，还原加密时的字节替换
static const unsigned char contrary_sbox[256] = {
    0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb,
    0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb,
    0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e,
    0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25,
    0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92,
    0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda, 0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84,
    0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06,
    0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b,
    0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73,
    0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e,
    0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b,
    0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4,
    0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f,
    0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef,
    0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61,
    0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d
};

// --------------------------- 有限域乘法工具函数 ---------------------------
// GF(2^8)有限域乘法：x * 2（左移1位，模0x1B）
// 说明：AES列混合操作的基础，有限域模多项式为x⁸+x⁴+x³+x+1（0x1B）
static unsigned char x2time(unsigned char x) {
    if (x & 0x80) { // 若最高位为1（x ≥ 0x80），左移后会溢出，需异或模值0x1B
        return (((x << 1) ^ 0x1B) & 0xFF); // 左移1位 + 模运算，确保8位
    }
    return x << 1; // 最高位为0，直接左移1位
}

// GF(2^8)有限域乘法：x * 3 = (x*2) XOR x
static unsigned char x3time(unsigned char x) {
    return (x2time(x) ^ x);
}

// GF(2^8)有限域乘法：x * 4 = (x*2)*2
static unsigned char x4time(unsigned char x) {
    return (x2time(x2time(x)));
}

// GF(2^8)有限域乘法：x * 8 = (x*2)*2*2
static unsigned char x8time(unsigned char x) {
    return (x2time(x2time(x2time(x))));
}

// GF(2^8)有限域乘法：x * 9 = (x*8) XOR x
static unsigned char x9time(unsigned char x) {
    return (x8time(x) ^ x);
}

// GF(2^8)有限域乘法：x * 11 = (x*8) XOR (x*2) XOR x
static unsigned char xBtime(unsigned char x) {
    return (x8time(x) ^ x2time(x) ^ x);
}

// GF(2^8)有限域乘法：x * 13 = (x*8) XOR (x*4) XOR x
static unsigned char xDtime(unsigned char x) {
    return (x8time(x) ^ x4time(x) ^ x);
}

// GF(2^8)有限域乘法：x * 14 = (x*8) XOR (x*4) XOR (x*2)
static unsigned char xEtime(unsigned char x) {
    return (x8time(x) ^ x4time(x) ^ x2time(x));
}

// --------------------------- AES核心变换函数（加密） ---------------------------
// 列混合（MixColumns）：加密时对16字节数据块的列进行线性变换
// 参数：col - 指向16字节数据块的指针（按列存储）
// 原理：每列4个字节通过有限域乘法和异或重新组合，扩散数据
static void MixColumns(unsigned char* col) {
    unsigned char tmp[4]; // 临时存储变换后的列数据
    int i;
    // 遍历4列（每列4字节，数据块共16字节=4列×4行）
    for (i = 0; i < 4; i++, col += 4) {
        // 列混合公式（AES标准）：每列字节按 [2,3,1,1] 等系数混合
        tmp[0] = x2time(col[0]) ^ x3time(col[1]) ^ col[2] ^ col[3];
        tmp[1] = col[0] ^ x2time(col[1]) ^ x3time(col[2]) ^ col[3];
        tmp[2] = col[0] ^ col[1] ^ x2time(col[2]) ^ x3time(col[3]);
        tmp[3] = x3time(col[0]) ^ col[1] ^ col[2] ^ x2time(col[3]);
        // 将变换结果写回原数据块
        col[0] = tmp[0];
        col[1] = tmp[1];
        col[2] = tmp[2];
        col[3] = tmp[3];
    }
}

// 行移位（ShiftRows）：加密时对数据块的行进行循环左移
// 参数：col - 指向16字节数据块的指针（按行存储：第0行[0,4,8,12]，第1行[1,5,9,13]等）
// 原理：第0行不移位，第1行左移1位，第2行左移2位，第3行左移3位，扩散数据
static void ShiftRows(unsigned char* col) {
    unsigned char t; // 临时变量用于交换字节

    // 第1行（索引1,5,9,13）：左移1位
    t = col[1];
    col[1] = col[5];
    col[5] = col[9];
    col[9] = col[13];
    col[13] = t;

    // 第2行（索引2,6,10,14）：左移2位
    t = col[2];
    col[2] = col[10];
    col[10] = t;
    t = col[6];
    col[6] = col[14];
    col[14] = t;

    // 第3行（索引3,7,11,15）：左移3位（等价于右移1位）
    t = col[15];
    col[15] = col[11];
    col[11] = col[7];
    col[7] = col[3];
    col[3] = t;
}

// 字节替换（SubBytes）：加密时用S盒替换数据块中所有字节
// 参数：col - 指向16字节数据块的指针
// 作用：引入非线性变换，使明文与密文的关系更复杂
static void SubBytes(unsigned char* col) {
    int x;
    for (x = 0; x < 16; x++) {
        col[x] = sbox[col[x]]; // 逐个字节替换
    }
}

// --------------------------- AES核心变换函数（解密） ---------------------------
// 逆列混合（Contrary_MixColumns）：解密时还原列混合操作
// 参数：col - 指向16字节数据块的指针
// 原理：使用列混合的逆变换公式，系数为[14,11,13,9]等
static void Contrary_MixColumns(unsigned char* col) {
    unsigned char tmp[4]; // 临时存储逆变换后的列数据
    int x;
    // 遍历4列
    for (x = 0; x < 4; x++, col += 4) {
        // 逆列混合公式（AES标准）
        tmp[0] = xEtime(col[0]) ^ xBtime(col[1]) ^ xDtime(col[2]) ^ x9time(col[3]);
        tmp[1] = x9time(col[0]) ^ xEtime(col[1]) ^ xBtime(col[2]) ^ xDtime(col[3]);
        tmp[2] = xDtime(col[0]) ^ x9time(col[1]) ^ xEtime(col[2]) ^ xBtime(col[3]);
        tmp[3] = xBtime(col[0]) ^ xDtime(col[1]) ^ x9time(col[2]) ^ xEtime(col[3]);
        // 写回原数据块
        col[0] = tmp[0];
        col[1] = tmp[1];
        col[2] = tmp[2];
        col[3] = tmp[3];
    }
}

// 逆行移位（Contrary_ShiftRows）：解密时还原行移位操作
// 参数：col - 指向16字节数据块的指针
// 原理：与行移位相反：第0行不移位，第1行右移1位，第2行右移2位，第3行右移3位
static void Contrary_ShiftRows(unsigned char* col) {
    unsigned char t; // 临时变量用于交换字节

    // 第1行（索引1,5,9,13）：右移1位
    t = col[13];
    col[13] = col[9];
    col[9] = col[5];
    col[5] = col[1];
    col[1] = t;

    // 第2行（索引2,6,10,14）：右移2位（与左移2位相同）
    t = col[2];
    col[2] = col[10];
    col[10] = t;
    t = col[6];
    col[6] = col[14];
    col[14] = t;

    // 第3行（索引3,7,11,15）：右移3位（等价于左移1位）
    t = col[3];
    col[3] = col[7];
    col[7] = col[11];
    col[11] = col[15];
    col[15] = t;
}

// 逆字节替换（Contrary_SubBytes）：解密时用逆S盒还原字节替换
// 参数：col - 指向16字节数据块的指针
static void Contrary_SubBytes(unsigned char* col) {
    int x;
    for (x = 0; x < 16; x++) {
        col[x] = contrary_sbox[col[x]]; // 逐个字节还原
    }
}

// --------------------------- 密钥扩展函数 ---------------------------
// 密钥扩展（ScheduleKey）：将16字节原始密钥扩展为176字节轮密钥（AES-128）
// 参数：
//   inkey - 输入的16字节原始密钥（AES-128）
//   outkey - 输出的扩展密钥（11轮 × 16字节 = 176字节）
//   Nk - 密钥长度（AES-128对应Nk=4，即4个32位字）
//   Nr - 加密轮数（AES-128对应Nr=10）
// 原理：通过循环移位、S盒替换、异或Rcon，生成每轮的独立密钥
void ScheduleKey(unsigned char* inkey, unsigned char* outkey, int Nk, int Nr) {
    unsigned char temp[4]; // 临时存储4字节（1个32位字）
    int x, i;

    // 步骤1：将原始密钥复制到扩展密钥的前Nk个32位字（16字节）
    for (i = 0; i < (4 * Nk); i++) {
        outkey[i] = inkey[i];
    }

    i = Nk; // 从第Nk个32位字开始扩展
    // 步骤2：循环生成剩余的扩展密钥（共4*(Nr+1)个32位字）
    while (i < (4 * (Nr + 1))) {
        // 步骤2.1：取上一个32位字作为临时变量temp
        for (x = 0; x < 4; x++) {
            temp[x] = outkey[(4 * (i - 1)) + x];
        }

        // 步骤2.2：若当前是Nk的整数倍（每轮第一个32位字），执行特殊处理
        if (i % Nk == 0) {
            // a. 循环左移1字节（temp[0]→temp[1], temp[1]→temp[2], temp[3]→temp[0]）
            unsigned char t = temp[0];
            temp[0] = temp[1];
            temp[1] = temp[2];
            temp[2] = temp[3];
            temp[3] = t;

            // b. S盒替换temp中的每个字节
            for (x = 0; x < 4; x++) {
                temp[x] = sbox[temp[x]];
            }

            // c. 异或当前轮的Rcon常量（仅第一个字节异或，其余为0）
            temp[0] ^= Rcon[(i / Nk) - 1];
        }

        // 步骤2.3：异或前Nk个32位字的对应字节，生成当前32位字
        for (x = 0; x < 4; x++) {
            outkey[(4 * i) + x] = outkey[(4 * (i - Nk)) + x] ^ temp[x];
        }

        i++; // 继续生成下一个32位字
    }
}

// --------------------------- 轮密钥加函数 ---------------------------
// 轮密钥加（AddRoundKey）：将当前轮密钥与数据块逐字节异或
// 参数：
//   col - 16字节数据块
//   expansionkey - 扩展后的轮密钥
//   round - 当前轮数（0~Nr）
// 作用：唯一依赖密钥的操作，将密钥信息融入数据块，加密和解密逻辑相同
static void AddRoundKey(unsigned char* col, unsigned char* expansionkey, int round) {
    int x;
    for (x = 0; x < 16; x++) {
        // 轮密钥起始位置 = 轮数 × 16字节（每轮16字节密钥）
        col[x] ^= expansionkey[(round << 4) + x];
    }
}

// --------------------------- 顶层加密/解密函数 ---------------------------
// AES加密主函数（AesEncrypt）：对单个16字节数据块进行加密
// 参数：
//   blk - 输入/输出：16字节明文块（加密后变为密文块）
//   expansionkey - 扩展后的轮密钥（176字节）
//   Nr - 加密轮数（AES-128对应Nr=10）
// 流程：初始轮（轮密钥加）→ 10轮主轮 → 最终轮（无列混合）
void AesEncrypt(unsigned char* blk, unsigned char* expansionkey, int Nr) {
    int round;

    // 初始轮：仅执行轮密钥加（无字节替换、行移位、列混合）
    AddRoundKey(blk, expansionkey, 0);

    // 主轮（1~9轮）：字节替换 → 行移位 → 列混合 → 轮密钥加
    for (round = 1; round <= (Nr - 1); round++) {
        SubBytes(blk);
        ShiftRows(blk);
        MixColumns(blk);
        AddRoundKey(blk, expansionkey, round);
    }

    // 最终轮（第10轮）：字节替换 → 行移位 → 轮密钥加（无列混合）
    SubBytes(blk);
    ShiftRows(blk);
    AddRoundKey(blk, expansionkey, Nr);
}

// AES解密主函数（Contrary_AesEncrypt）：对单个16字节数据块进行解密
// 参数：
//   blk - 输入/输出：16字节密文块（解密后变为明文块）
//   expansionkey - 扩展后的轮密钥（176字节）
//   Nr - 解密轮数（与加密轮数相同，AES-128对应Nr=10）
// 流程：初始轮（轮密钥加）→ 10轮逆主轮 → 最终逆轮
void Contrary_AesEncrypt(unsigned char* blk, unsigned char* expansionkey, int Nr) {
    int x;

    // 初始轮：用最后一轮密钥执行轮密钥加
    AddRoundKey(blk, expansionkey, Nr);

    // 逆行移位 → 逆字节替换（还原最终轮的操作）
    Contrary_ShiftRows(blk);
    Contrary_SubBytes(blk);

    // 逆主轮（9~1轮）：轮密钥加 → 逆列混合 → 逆行移位 → 逆字节替换
    for (x = (Nr - 1); x >= 1; x--) {
        AddRoundKey(blk, expansionkey, x);
        Contrary_MixColumns(blk);
        Contrary_ShiftRows(blk);
        Contrary_SubBytes(blk);
    }

    // 最终逆轮：用第0轮密钥执行轮密钥加（还原初始轮）
    AddRoundKey(blk, expansionkey, 0);
}

// --------------------------- 填充/去填充函数（支持任意长度明文） ---------------------------
// PKCS#7填充（PKCS7Padding）：将明文补成16字节整数倍（AES分组长度）
// 参数：
//   input - 原始明文
//   input_len - 原始明文长度
//   output - 输出：填充后的明文（需手动释放内存）
//   output_len - 输出：填充后的明文长度
// 规则：填充长度 = 16 - (input_len % 16)，填充字节值 = 填充长度
void PKCS7Padding(unsigned char* input, int input_len, unsigned char** output, int* output_len) {
    int pad_len = 16 - (input_len % 16); // 计算需要填充的字节数
    *output_len = input_len + pad_len;   // 填充后的总长度
    *output = (unsigned char*)malloc(*output_len); // 分配内存
    memcpy(*output, input, input_len);   // 复制原始明文

    // 填充：从原始明文末尾开始，填充pad_len个字节，每个字节值为pad_len
    for (int i = 0; i < pad_len; i++) {
        (*output)[input_len + i] = pad_len;
    }
}

// 移除PKCS#7填充（RemovePKCS7Padding）：解密后还原原始明文
// 参数：
//   input - 填充后的明文（解密后的结果）
//   input_len - 填充后的明文长度（16字节整数倍）
//   output - 输出：原始明文（需手动释放内存）
//   output_len - 输出：原始明文长度
// 规则：最后一个字节的值 = 填充长度，截取前（input_len - 填充长度）个字节
void RemovePKCS7Padding(unsigned char* input, int input_len, unsigned char** output, int* output_len) {
    int pad_len = input[input_len - 1]; // 最后一个字节是填充长度
    *output_len = input_len - pad_len;  // 原始明文长度
    *output = (unsigned char*)malloc(*output_len); // 分配内存
    memcpy(*output, input, *output_len); // 复制原始明文（去掉填充部分）
}

// --------------------------- 支持任意长度的加密/解密函数 ---------------------------
// 任意长度明文加密（AES_Encrypt_AnyLength）：封装填充+分块加密
// 参数：
//   plaintext - 原始明文（任意长度）
//   plaintext_len - 原始明文长度
//   key - 16字节加密密钥
//   ciphertext - 输出：密文（需手动释放内存）
//   ciphertext_len - 输出：密文长度（16字节整数倍）
void AES_Encrypt_AnyLength(unsigned char* plaintext, int plaintext_len, unsigned char* key, unsigned char** ciphertext,
    int* ciphertext_len) {
    unsigned char expansionkey[15 * 16]; // 扩展密钥缓冲区（最大支持AES-256，此处用176字节）
    unsigned char* padded_plaintext;     // 填充后的明文
    int padded_len;                      // 填充后的明文长度

    // 步骤1：密钥扩展（AES-128：Nk=4，Nr=10）
    ScheduleKey(key, expansionkey, 4, 10);

    // 步骤2：PKCS#7填充，将明文补成16字节整数倍
    PKCS7Padding(plaintext, plaintext_len, &padded_plaintext, &padded_len);

    // 步骤3：分配密文内存（密文长度=填充后明文长度）
    *ciphertext = (unsigned char*)malloc(padded_len);
    *ciphertext_len = padded_len;

    // 步骤4：分块加密（每块16字节）
    for (int i = 0; i < padded_len; i += 16) {
        AesEncrypt(padded_plaintext + i, expansionkey, 10); // 加密当前块
        memcpy(*ciphertext + i, padded_plaintext + i, 16);  // 复制密文块
    }

    // 释放填充后的明文内存
    free(padded_plaintext);
}

// 任意长度密文解密（AES_Decrypt_AnyLength）：封装分块解密+去填充
// 参数：
//   ciphertext - 密文（16字节整数倍长度）
//   ciphertext_len - 密文长度
//   key - 16字节解密密钥（与加密密钥相同）
//   plaintext - 输出：原始明文（需手动释放内存）
//   plaintext_len - 输出：原始明文长度
void AES_Decrypt_AnyLength(unsigned char* ciphertext, int ciphertext_len, unsigned char* key, unsigned char** plaintext,
    int* plaintext_len) {
    unsigned char expansionkey[15 * 16]; // 扩展密钥缓冲区
    unsigned char* padded_plaintext = (unsigned char*)malloc(ciphertext_len); // 填充后的明文缓冲区

    // 步骤1：密钥扩展（与加密时相同）
    ScheduleKey(key, expansionkey, 4, 10);

    // 步骤2：分块解密（每块16字节）
    for (int i = 0; i < ciphertext_len; i += 16) {
        Contrary_AesEncrypt(ciphertext + i, expansionkey, 10); // 解密当前块
        memcpy(padded_plaintext + i, ciphertext + i, 16);      // 复制填充后的明文块
    }

    // 步骤3：移除PKCS#7填充，还原原始明文
    RemovePKCS7Padding(padded_plaintext, ciphertext_len, plaintext, plaintext_len);

    // 释放填充后的明文内存
    free(padded_plaintext);
}

// --------------------------- 主函数（用户交互+调用加密解密） ---------------------------
int main(void) {
    unsigned char key[17];                  // 16字节密钥（+1用于存储字符串结束符）
    unsigned char plaintext[1024];          // 输入明文缓冲区（最大1023字节）
    unsigned char* ciphertext = NULL;       // 加密后的密文（动态分配）
    unsigned char* decrypted_plaintext = NULL; // 解密后的明文（动态分配）
    int plaintext_len, ciphertext_len, decrypted_plaintext_len; // 各数据长度

    printf("AES Encryption with Any Length Plaintext\n");
    printf("=========================================\n");

    // 步骤1：读取用户输入的明文
    printf("Enter plaintext (up to 1023 characters):\n");
    fgets((char*)plaintext, 1024, stdin); // 读取明文（包含换行符）
    plaintext_len = strlen((char*)plaintext);
    // 去掉fgets读取的换行符（若存在）
    if (plaintext[plaintext_len - 1] == '\n') {
        plaintext[--plaintext_len] = '\0';
    }

    // 步骤2：读取用户输入的16字节密钥
    printf("Enter 16-byte key:\n");
    scanf("%16s", key); // 限制输入16个字符（避免密钥过长）
    key[16] = '\0';     // 手动添加字符串结束符

    // 步骤3：执行加密
    AES_Encrypt_AnyLength(plaintext, plaintext_len, key, &ciphertext, &ciphertext_len);
    printf("\nCiphertext (hex):\n");
    // 以十六进制格式输出密文（每个字节占2位）
    for (int i = 0; i < ciphertext_len; i++) {
        printf("%02x", ciphertext[i]);
    }
    printf("\n");

    // 步骤4：执行解密
    AES_Decrypt_AnyLength(ciphertext, ciphertext_len, key, &decrypted_plaintext, &decrypted_plaintext_len);
    printf("Decrypted Plaintext:\n");
    // 输出解密后的明文
    for (int i = 0; i < decrypted_plaintext_len; i++) {
        printf("%c", decrypted_plaintext[i]);
    }
    printf("\n");

    // 步骤5：释放动态分配的内存（避免内存泄漏）
    free(ciphertext);
    free(decrypted_plaintext);
    system("pause");
    return 0;
}