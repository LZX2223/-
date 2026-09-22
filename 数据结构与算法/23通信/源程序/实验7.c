#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_NODES 20
#define MAX_VALUE 1000

typedef struct {
    char ch;
    int weight;
    int lChild;
    int rChild;
    int parent;
    char hCode[MAX_NODES];
} HuffmanNode;

void initializeHuffmanTree(HuffmanNode* tree, int* weights, char* chars, int n) {
    for (int i = 0; i < 2 * n - 1; i++) {
        tree[i].ch = i < n ? chars[i] : '\0';
        tree[i].weight = i < n ? weights[i] : 0;
        tree[i].parent = -1;
        tree[i].lChild = -1;
        tree[i].rChild = -1;
        memset(tree[i].hCode, 0, sizeof(tree[i].hCode));
    }
}

void buildHuffmanTree(HuffmanNode* tree, int n) {
    for (int i = n; i < 2 * n - 1; i++) {
        int min1 = MAX_VALUE, min2 = MAX_VALUE;
        int idx1 = -1, idx2 = -1;

        for (int j = 0; j < i; j++) {
            if (tree[j].parent == -1) {
                if (tree[j].weight < min1) {
                    min2 = min1;
                    idx2 = idx1;
                    min1 = tree[j].weight;
                    idx1 = j;
                } else if (tree[j].weight < min2) {
                    min2 = tree[j].weight;
                    idx2 = j;
                }
            }
        }

        if (idx1 != -1 && idx2 != -1) {
            tree[idx1].parent = i;
            tree[idx2].parent = i;
            tree[i].lChild = idx1;
            tree[i].rChild = idx2;
            tree[i].weight = min1 + min2;
        }
    }
}

void generateHuffmanCodes(HuffmanNode* tree, int n) {
    char tempCode[MAX_NODES];
    for (int i = 0; i < n; i++) {
        int current = i;
        int parent = tree[current].parent;
        int codeLen = 0;
        
        while (parent != -1) {
            if (tree[parent].lChild == current) {
                tempCode[codeLen++] = '0';
            } else {
                tempCode[codeLen++] = '1';
            }
            current = parent;
            parent = tree[current].parent;
        }

        // Reverse the code
        for (int j = 0; j < codeLen; j++) {
            tree[i].hCode[j] = tempCode[codeLen - 1 - j];
        }
        tree[i].hCode[codeLen] = '\0';
    }
}

int main() {
    int nodeCount;
    printf("请输入叶子节点数量：\n");
    scanf("%d", &nodeCount);

    if (nodeCount <= 0 || nodeCount > MAX_NODES) {
        printf("无效的节点数量！\n");
        return 1;
    }

    char characters[MAX_NODES];
    int weights[MAX_NODES];
    HuffmanNode huffmanTree[2 * MAX_NODES - 1];

    printf("请输入%d个字符及其权值：\n", nodeCount);
    for (int i = 0; i < nodeCount; i++) {
        printf("请输入第%d个字符：\n", i + 1);
        scanf(" %c", &characters[i]);
        printf("请输入第%d个字符的权值：\n", i + 1);
        scanf("%d", &weights[i]);
    }

    initializeHuffmanTree(huffmanTree, weights, characters, nodeCount);
    buildHuffmanTree(huffmanTree, nodeCount);
    generateHuffmanCodes(huffmanTree, nodeCount);

    printf("\n生成的哈夫曼编码：\n");
    for (int i = 0; i < nodeCount; i++) {
        printf("%c: %s\n", huffmanTree[i].ch, huffmanTree[i].hCode);
    }

    return 0;
}
