#include <stdio.h>
#include <string.h>
#include <ctype.h>

// 你的密文（直接粘进去）
const char* ciphertext =
"DLHDRXHLLDLBRXHLLKSMFVRDNHXXVDLRWFHAYCHDLCYAKXHMGKXXHMFQKMRKNDODNRSYIXKCFYIKMYXZKAMRKNDODKAIVFQKDLDFDHXMFHFKHLABYHXDLNYLFSHMFFYFQYMKDLGQDNAFQKSKDMLYDLRWFAYCHDLMRKNDODKAMWNQRXHLLKSMHSKNHXXKAAYCHDLDLAKRKLAKLFFYKCRQHMDFQKOHNFFQHFFQKVNHLMYXZKRXHLLDLBRSYIXKCMOSYCHGDAKSHLBKYOAYCHDLMFVRDNHXKPHCRXKMYOAYCHDLMHSKIXYNUMFHNUDLBXYBDMFDNMGYSUOXYGCHLHBKCKLFHLASYIYFFHMURXHLLDLBQKLNKHMDLBXKAYCHDLDLAKRKLAKLFRXHLLKSNHLIKWMKAFYMYXZKRXHLLDLBRSYIXKCMDLHXXFQKMKZHSDYWMAYCHDLYLFQKYFQKSQHLAHSYWFKRXHLLKSDMFVRDNHXYOHAYCHDLMRKNDODNRXHLLKS";

int main() {
    int len = strlen(ciphertext);

    // 1. 单个字母计数
    int letter[26] = { 0 };

    // 2. bigram 计数 (26×26)
    int bigram[26][26] = { {0} };

    // 3. trigram 计数 (26×26×26 = 17 576) 用一维数组模拟三维
    int trigram[26 * 26 * 26] = { 0 };

    // 统计
    for (int i = 0; i < len; i++) {
        char c = toupper(ciphertext[i]);
        if (c < 'A' || c > 'Z') continue;

        int a = c - 'A';
        letter[a]++;

        // bigram
        if (i + 1 < len) {
            char c2 = toupper(ciphertext[i + 1]);
            if (c2 >= 'A' && c2 <= 'Z') {
                int b = c2 - 'A';
                bigram[a][b]++;
            }
        }

        // trigram
        if (i + 2 < len) {
            char c2 = toupper(ciphertext[i + 1]);
            char c3 = toupper(ciphertext[i + 2]);
            if (c2 >= 'A' && c2 <= 'Z' && c3 >= 'A' && c3 <= 'Z') {
                int idx = a * 676 + (c2 - 'A') * 26 + (c3 - 'A');  // 26^2=676
                trigram[idx]++;
            }
        }
    }

    // ==================== 输出 单个字母 ====================
    printf("=== 单个字母出现次数 ===\n");
    for (int i = 0; i < 26; i++) {
        if (letter[i] > 0)
            printf("%c: %d\n", 'A' + i, letter[i]);
    }
    printf("\n");

    // ==================== 输出 Bigram (前50个最常见) ====================
    printf("=== Bigram 相邻两个字母组合 (前50个) ===\n");
    struct Item2 { char a, b; int cnt; } list2[676];
    int n2 = 0;
    for (int i = 0; i < 26; i++)
        for (int j = 0; j < 26; j++)
            if (bigram[i][j]) {
                list2[n2].a = 'A' + i;
                list2[n2].b = 'A' + j;
                list2[n2].cnt = bigram[i][j];
                n2++;
            }

    // 降序排序
    for (int i = 0; i < n2 - 1; i++)
        for (int j = 0; j < n2 - i - 1; j++)
            if (list2[j].cnt < list2[j + 1].cnt) {
                struct Item2 t = list2[j];
                list2[j] = list2[j + 1];
                list2[j + 1] = t;
            }

    for (int i = 0; i < n2 && i < 50; i++)
        printf("%c%c : %d\n", list2[i].a, list2[i].b, list2[i].cnt);
    printf("\n");

    // ==================== 输出 Trigram (前50个最常见) ====================
    printf("=== Trigram 相邻三个字母组合 (前50个) ===\n");
    struct Item3 { char a, b, c; int cnt; } list3[17576];
    int n3 = 0;
    for (int idx = 0; idx < 26 * 26 * 26; idx++) {
        if (trigram[idx] == 0) continue;
        int a = idx / 676;
        int b = (idx / 26) % 26;
        int c = idx % 26;
        list3[n3].a = 'A' + a;
        list3[n3].b = 'A' + b;
        list3[n3].c = 'A' + c;
        list3[n3].cnt = trigram[idx];
        n3++;
    }

    // 降序排序
    for (int i = 0; i < n3 - 1; i++)
        for (int j = 0; j < n3 - i - 1; j++)
            if (list3[j].cnt < list3[j + 1].cnt) {
                struct Item3 t = list3[j];
                list3[j] = list3[j + 1];
                list3[j + 1] = t;
            }

    for (int i = 0; i < n3 && i < 50; i++)
        printf("%c%c%c : %d\n", list3[i].a, list3[i].b, list3[i].c, list3[i].cnt);

    return 0;
}