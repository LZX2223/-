#include <stdio.h>
#include <stdlib.h>

#define EMPTY -1
#define DELETED -2

typedef int ElemType;

typedef struct {
    ElemType key;
} HashNode;

typedef struct {
    HashNode *data;      // 动态分配的哈希表空间
    int tableSize;       // 哈希表长度
    int count;           // 当前已存入元素个数
    int method;          // 冲突处理方法：1 线性探测，2 二次探测
} HashTable;

/* 哈希函数：除留余数法 */
int Hash(HashTable *ht, ElemType key) {
    return key % ht->tableSize;
}

/* 初始化哈希表 */
void InitHashTable(HashTable *ht, int size, int method) {
    int i;

    ht->tableSize = size;
    ht->count = 0;
    ht->method = method;

    ht->data = (HashNode *)malloc(sizeof(HashNode) * size);
    if (ht->data == NULL) {
        printf("内存分配失败！\n");
        exit(1);
    }

    for (i = 0; i < size; i++) {
        ht->data[i].key = EMPTY;
    }
}

/* 根据冲突处理方式计算下一次探测位置 */
int GetNextPos(HashTable *ht, int start, int k) {
    int pos;

    if (ht->method == 1) {
        // 线性探测：H_i = (H_0 + i) % m
        pos = (start + k) % ht->tableSize;
    } else {
        // 二次探测：H_i = (H_0 ± i^2) % m
        if (k % 2 == 1) {
            pos = (start + (k + 1) / 2 * ((k + 1) / 2)) % ht->tableSize;
        } else {
            pos = (start - (k / 2) * (k / 2)) % ht->tableSize;
            if (pos < 0) {
                pos += ht->tableSize;
            }
        }
    }

    return pos;
}

/* 插入元素 */
int InsertHash(HashTable *ht, ElemType key) {
    int start, pos, i;

    if (ht->count >= ht->tableSize) {
        printf("哈希表已满，无法插入 %d！\n", key);
        return 0;
    }

    start = Hash(ht, key);
    pos = start;

    for (i = 0; i < ht->tableSize; i++) {
        if (ht->data[pos].key == EMPTY) {
            ht->data[pos].key = key;
            ht->count++;
            return 1;
        } else if (ht->data[pos].key == key) {
            printf("元素 %d 已存在，不重复插入。\n", key);
            return 0;
        } else {
            pos = GetNextPos(ht, start, i + 1);
        }
    }

    printf("插入 %d 失败，冲突无法解决。\n", key);
    return 0;
}

/* 创建哈希表 */
void CreateHashTable(HashTable *ht) {
    int size, n, method;
    int i, key;

    printf("请输入哈希表长度：");
    scanf("%d", &size);

    printf("请输入待插入元素个数：");
    scanf("%d", &n);

    printf("请选择冲突处理方法：1.线性探测  2.二次探测：");
    scanf("%d", &method);

    if (method != 1 && method != 2) {
        printf("输入错误，默认采用线性探测法。\n");
        method = 1;
    }

    InitHashTable(ht, size, method);

    printf("请依次输入 %d 个关键字：\n", n);
    for (i = 0; i < n; i++) {
        scanf("%d", &key);
        InsertHash(ht, key);
    }
}

/* 哈希查找 */
int SearchHash(HashTable *ht, ElemType key) {
    int start, pos, i;

    start = Hash(ht, key);
    pos = start;

    for (i = 0; i < ht->tableSize; i++) {
        if (ht->data[pos].key == EMPTY) {
            return -1;
        }

        if (ht->data[pos].key == key) {
            return pos;
        }

        pos = GetNextPos(ht, start, i + 1);
    }

    return -1;
}

/* 输出哈希表 */
void PrintHashTable(HashTable *ht) {
    int i;

    printf("\n当前哈希表如下：\n");
    printf("下标：");
    for (i = 0; i < ht->tableSize; i++) {
        printf("%4d", i);
    }

    printf("\n数据：");
    for (i = 0; i < ht->tableSize; i++) {
        if (ht->data[i].key == EMPTY) {
            printf("%4s", "-");
        } else {
            printf("%4d", ht->data[i].key);
        }
    }

    printf("\n");
}

/* 释放空间 */
void DestroyHashTable(HashTable *ht) {
    if (ht->data != NULL) {
        free(ht->data);
        ht->data = NULL;
    }
    ht->tableSize = 0;
    ht->count = 0;
}

int main() {
    HashTable ht;
    int key, pos;

    CreateHashTable(&ht);
    PrintHashTable(&ht);

    while (1) {
        printf("\n请输入要查找的关键字，输入 -1 结束：");
        scanf("%d", &key);

        if (key == -1) {
            break;
        }

        pos = SearchHash(&ht, key);

        if (pos == -1) {
            printf("查找失败，关键字 %d 不在哈希表中。\n", key);
        } else {
            printf("查找成功，关键字 %d 的位置是 %d。\n", key, pos);
        }
    }

    DestroyHashTable(&ht);

    return 0;
}