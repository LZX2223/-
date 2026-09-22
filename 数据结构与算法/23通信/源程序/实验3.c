#include <stdio.h>
#include <stdlib.h>
#define QUEUE_INIT_SIZE 20

typedef struct BiTNode {
    char data;
    struct BiTNode* lchild;
    struct BiTNode* rchild;
} BiTNode, *BiTree;

typedef struct {
    BiTNode** base;    // 存储指针数组
    int front;         // 队头索引
    int rear;          // 队尾索引
    int capacity;      // 队列容量
} Queue;

// 初始化队列
int InitQueue(Queue* q) {
    q->base = (BiTNode**)malloc(QUEUE_INIT_SIZE * sizeof(BiTNode*));
    if (!q->base) return 0;
    q->front = q->rear = 0;
    q->capacity = QUEUE_INIT_SIZE;
    return 1;
}

// 判断队列是否为空
int QueueEmpty(Queue q) {
    return q.front == q.rear;
}

// 入队操作
int EnQueue(Queue* q, BiTNode* node) {
    // 检查队列是否已满
    if ((q->rear + 1) % q->capacity == q->front) {
        // 队列扩容
        int new_capacity = q->capacity * 2;
        BiTNode** new_base = (BiTNode**)realloc(q->base, new_capacity * sizeof(BiTNode*));
        if (!new_base) return 0;
        q->base = new_base;
        
        // 调整元素位置（环形缓冲区可能需要数据搬移）
        if (q->rear < q->front) {
            for (int i = 0; i < q->rear; i++) {
                q->base[q->capacity + i] = q->base[i];
            }
            q->rear += q->capacity;
        }
        q->capacity = new_capacity;
    }
    
    q->base[q->rear] = node;
    q->rear = (q->rear + 1) % q->capacity;
    return 1;
}

// 出队操作
int DeQueue(Queue* q, BiTNode** node) {
    if (QueueEmpty(*q)) return 0;
    *node = q->base[q->front];
    q->front = (q->front + 1) % q->capacity;
    return 1;
}

// 释放队列内存
void FreeQueue(Queue* q) {
    free(q->base);
    q->base = NULL;
}

// 创建二叉树（非递归方式）
void CreateBiTree(BiTree* T) {
    char ch;
    Queue q;
    BiTNode *node, *p;
    int flag = 0; // 0:左孩子 1:右孩子
    
    InitQueue(&q);
    
    printf("请输入根节点: ");
    ch = getchar();
    if (ch == '*' || ch == '\n') {
        *T = NULL;
        return;
    }
    
    *T = (BiTree)malloc(sizeof(BiTNode));
    (*T)->data = ch;
    (*T)->lchild = (*T)->rchild = NULL;
    
    EnQueue(&q, *T);
    
    while (!QueueEmpty(q)) {
        DeQueue(&q, &node);
        
        // 处理左孩子
        printf("请输入%c的左孩子(*表示空): ", node->data);
        while ((ch = getchar()) == '\n'); // 跳过换行符
        if (ch != '*') {
            p = (BiTree)malloc(sizeof(BiTNode));
            p->data = ch;
            p->lchild = p->rchild = NULL;
            node->lchild = p;
            EnQueue(&q, p);
        }
        
        // 处理右孩子
        printf("请输入%c的右孩子(*表示空): ", node->data);
        while ((ch = getchar()) == '\n'); // 跳过换行符
        if (ch != '*') {
            p = (BiTree)malloc(sizeof(BiTNode));
            p->data = ch;
            p->lchild = p->rchild = NULL;
            node->rchild = p;
            EnQueue(&q, p);
        }
    }
    
    FreeQueue(&q);
}

// 释放二叉树内存
void FreeBiTree(BiTree T) {
    if (T) {
        FreeBiTree(T->lchild);
        FreeBiTree(T->rchild);
        free(T);
    }
}

// 层次遍历
void LevelTraverse(BiTree T) {
    if (!T) {
        printf("空树\n");
        return;
    }
    
    Queue q;
    if (!InitQueue(&q)) return;
    
    int current_level = 1;
    int next_level = 0;
    int level = 1;
    
    EnQueue(&q, T);
    
    printf("第%d层: ", level);
    
    while (!QueueEmpty(q)) {
        BiTNode* node;
        DeQueue(&q, &node);
        printf("%c ", node->data);
        current_level--;
        
        if (node->lchild) {
            EnQueue(&q, node->lchild);
            next_level++;
        }
        if (node->rchild) {
            EnQueue(&q, node->rchild);
            next_level++;
        }
        
        if (current_level == 0 && next_level > 0) {
            level++;
            printf("\n第%d层: ", level);
            current_level = next_level;
            next_level = 0;
        }
    }
    
    FreeQueue(&q);
    printf("\n");
}

int main() {
    BiTree T = NULL;
    
    printf("创建二叉树(按层次顺序输入节点，*表示空节点)\n");
    CreateBiTree(&T);
    
    printf("\n层次遍历结果:\n");
    LevelTraverse(T);
    
    FreeBiTree(T);
    return 0;
}
