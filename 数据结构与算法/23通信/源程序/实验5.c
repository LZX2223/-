#include <stdio.h>
#include <stdlib.h>
#define SIZE 100

typedef int ElemType;

typedef struct {
    ElemType key;
} KeyType;

typedef struct {
    KeyType elem[SIZE];
    int length;    // 当前元素数量
    int size;      // 哈希表总大小
    int collision_method; // 冲突解决方法 (1:线性探测 2:二次探测)
} HashTable;

// 初始化增量序列 (用于二次探测)
void initIncrements(int d[], int size) {
    for(int i=1; i<size; i++) {
        if(i%2 == 1) 
            d[i] = (i/2 + 1) * (i/2 + 1);
        else 
            d[i] = -d[i-1];
    }
}

// 哈希函数
int hash(HashTable h, int key) {
    return key % h.size;
}

// 线性探测
int linearProbe(HashTable h, int i, int p) {
    return (p + i) % h.size;
}

// 二次探测
int quadraticProbe(HashTable h, int i, int p, int d[]) {
    return (p + d[i]) % h.size;
}

// 初始化哈希表
void initHash(HashTable* h) {
    for(int i=0; i<h->size; i++) {
        h->elem[i].key = -1; // -1表示空位置
    }
}

// 创建哈希表
void createHash(HashTable* h) {
    printf("输入哈希表大小和元素数量: ");
    scanf("%d %d", &h->size, &h->length);
    
    printf("选择冲突解决方法(1-线性探测 2-二次探测): ");
    scanf("%d", &h->collision_method);
    
    initHash(h);
    int d[SIZE];
    if(h->collision_method == 2) {
        initIncrements(d, h->size);
    }

    printf("输入%d个元素:\n", h->length);
    for(int j=0; j<h->length; j++) {
        int key;
        scanf("%d", &key);
        
        int p = hash(*h, key);
        int attempts = 0;
        
        // 查找可插入位置
        while(h->elem[p].key != -1 && h->elem[p].key != key && attempts < h->size) {
            attempts++;
            if(h->collision_method == 1) {
                p = linearProbe(*h, attempts, p);
            } else {
                p = quadraticProbe(*h, attempts, p, d);
            }
        }
        
        if(attempts >= h->size) {
            printf("无法解决冲突! 跳过该元素\n");
            j--; // 重新尝试当前元素
            continue;
        }
        
        if(h->elem[p].key == -1) {
            h->elem[p].key = key;
        } else {
            printf("重复元素 %d 已存在\n", key);
            j--; // 不计数重复元素
        }
    }
}

// 查找元素
int searchHash(HashTable h, int key) {
    int d[SIZE];
    if(h.collision_method == 2) {
        initIncrements(d, h.size);
    }
    
    int p = hash(h, key);
    int attempts = 0;
    
    while(h.elem[p].key != -1 && h.elem[p].key != key && attempts < h.size) {
        attempts++;
        if(h.collision_method == 1) {
            p = linearProbe(h, attempts, p);
        } else {
            p = quadraticProbe(h, attempts, p, d);
        }
    }
    
    return (h.elem[p].key == key) ? p : -1;
}

// 打印哈希表
void printHash(HashTable h) {
    printf("\n哈希表(大小=%d, 元素=%d):\n", h.size, h.length);
    printf("索引: ");
    for(int i=0; i<h.size; i++) {
        printf("%3d", i);
    }
    printf("\n键值: ");
    for(int i=0; i<h.size; i++) {
        if(h.elem[i].key == -1) 
            printf("  -");
        else 
            printf("%3d", h.elem[i].key);
    }
    printf("\n");
}

int main() {
    HashTable t;
    createHash(&t);
    printHash(t);
    
    while(1) {
        int key;
        printf("\n输入要查找的键值(输入-1退出): ");
        scanf("%d", &key);
        
        if(key == -1) break;
        
        int pos = searchHash(t, key);
        if(pos != -1) {
            printf("找到键值 %d 在位置 %d\n", key, pos);
        } else {
            printf("未找到键值 %d\n", key);
        }
    }
    
    return 0;
}
