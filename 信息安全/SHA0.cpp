#include <iostream>
#include <string>
#include <vector>
#include <cstdint>
#include <iomanip>
#include <sstream>
using namespace std;

/**
 * SHA-0 哈希算法实现类
 * SHA-0 是 NIST 于1993年发布的原始 Secure Hash Algorithm
 * 输出160位（40个十六进制字符）摘要
 * 注意：SHA-0 已存在已知碰撞漏洞，仅用于教学和历史研究
 */
class SHA0 {
private:
    // 五个32位状态寄存器（H0 ~ H4），初始值为 SHA-0 标准指定（大端序）
    uint32_t state[5] = {
        0x67452301,
        0xEFCDAB89,
        0x98BADCFE,
        0x10325476,
        0xC3D2E1F0
    };

    // 辅助函数：32位循环左移（防止移位量 >=32 导致未定义行为）
    static uint32_t rotate_left(uint32_t x, uint32_t n) {
        n %= 32;
        return (x << n) | (x >> (32 - n));
    }

    /**
     * 消息填充（Padding）
     * 按照 Merkle-Damgård 结构要求，将任意长度消息填充为 512 位的倍数
     * 步骤：
     * 1. 追加一个 '1' 位（字节 0x80）
     * 2. 追加若干 0 字节，使填充后长度 mod 512 = 448 位（即 mod 64 字节 = 56 字节）
     * 3. 追加原始消息的位长度（64 位小端序，低位先）
     */
    void pad(const vector<uint8_t>& input, vector<uint8_t>& output) {
        output = input;                     // 复制原始消息
        output.push_back(0x80);             // 追加 '1' 位（0x80 = 10000000）

        // 补 0 直到长度 mod 64 == 56（剩余 8 字节用于长度）
        while ((output.size() % 64) != 56) {
            output.push_back(0x00);
        }

        // 计算原始消息的位长度（字节数 * 8）
        uint64_t bit_len = static_cast<uint64_t>(input.size()) * 8;
        // 追加 64 位长度（小端序，8 个字节）
        for (int i = 0; i < 8; ++i) {
            output.push_back(static_cast<uint8_t>(bit_len >> (i * 8)));
        }
    }

    /**
     * 处理一个 512 位（64 字节）消息块
     * 这是 SHA-0 的核心压缩函数
     */
    void process_block(const uint8_t* block) {
        uint32_t W[80];  // 消息调度数组，前16个直接来自块，后64个扩展得到

        // 第一步：将 64 字节块按大端序拆分为 16 个 32 位字 W[0..15]
        for (int i = 0; i < 16; ++i) {
            W[i] = (uint32_t(block[4 * i]) << 24) |
                (uint32_t(block[4 * i + 1]) << 16) |
                (uint32_t(block[4 * i + 2]) << 8) |
                uint32_t(block[4 * i + 3]);
        }

        // 第二步：消息扩展（SHA-0 关键特征：无左旋1位）
        // 对于 t = 16 到 79：W[t] = W[t-3] ⊕ W[t-8] ⊕ W[t-14] ⊕ W[t-16]
        for (int i = 16; i < 80; ++i) {
            W[i] = W[i - 3] ^ W[i - 8] ^ W[i - 14] ^ W[i - 16];
            
        }

        // 初始化工作变量 A~E 为当前状态
        uint32_t A = state[0];
        uint32_t B = state[1];
        uint32_t C = state[2];
        uint32_t D = state[3];
        uint32_t E = state[4];

        uint32_t temp, f, k;  // 临时变量

        // 第三步：80 轮主循环（分为 4 组，每组 20 轮）
        for (int t = 0; t < 80; ++t) {
            // 选择非线性函数 f 和常量 k
            if (t < 20) {
                f = (B & C) | (~B & D);          // f = (B AND C) OR (NOT B AND D)
                k = 0x5A827999;
            }
            else if (t < 40) {
                f = B ^ C ^ D;                   // f = B XOR C XOR D
                k = 0x6ED9EBA1;
            }
            else if (t < 60) {
                f = (B & C) | (B & D) | (C & D);  // f = (B AND C) OR (B AND D) OR (C AND D)
                k = 0x8F1BBCDC;
            }
            else {
                f = B ^ C ^ D;                   // f = B XOR C XOR D
                k = 0xCA62C1D6;
            }

            // 核心更新公式
            temp = rotate_left(A, 5) + f + E + k + W[t];  // A 左旋5位 + f + E + k + W[t]
            E = D;                                        // E ← D
            D = C;                                        // D ← C
            C = rotate_left(B, 30);                       // C ← B 左旋30位
            B = A;                                        // B ← A
            A = temp;                                     // A ← temp
        }

        // 第四步：将本块计算结果累加到全局状态
        state[0] += A;
        state[1] += B;
        state[2] += C;
        state[3] += D;
        state[4] += E;
    }

    // 重置状态为初始值（每次计算新哈希前调用）
    void reset() {
        state[0] = 0x67452301;
        state[1] = 0xEFCDAB89;
        state[2] = 0x98BADCFE;
        state[3] = 0x10325476;
        state[4] = 0xC3D2E1F0;
    }

public:
    /**
     * 计算输入字符串的 SHA-0 哈希值
     * @param input 任意长度的输入字符串
     * @return 40 个大写十六进制字符的摘要字符串
     */
    string hash(const string& input) {
        reset();  // 重置状态

        // 将字符串转为字节向量
        vector<uint8_t> bytes(input.begin(), input.end());

        // 填充消息
        vector<uint8_t> padded;
        pad(bytes, padded);

        // 逐块处理（每块 64 字节）
        for (size_t i = 0; i < padded.size(); i += 64) {
            process_block(&padded[i]);
        }

        // 格式化输出：5 个 32 位字直接转为大写十六进制（大端序已保持）
        stringstream ss;
        ss << hex << uppercase << setfill('0');
        for (int i = 0; i < 5; ++i) {
            ss << setw(8) << state[i];  // 每个字占8位十六进制
        }
        return ss.str();
    }
};

// 主函数：测试用
int main() {
    SHA0 sha0;
    string input;
    cout << "输入字符串: ";
    getline(cin, input);  // 支持包含空格的输入

    string digest = sha0.hash(input);
    cout << "SHA-0 摘要 (160位，40个十六进制字符): " << digest << endl;
    system("pause");
   
    return 0;
}