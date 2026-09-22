#include <stdio.h>
#include <stdlib.h>

#define QUEUE_MAX_SIZE 100

// 二叉树结点结构
typedef struct TreeNode
{
    char data;                  // 结点数据
    struct TreeNode *left;      // 左孩子指针
    struct TreeNode *right;     // 右孩子指针
} TreeNode, *BiTree;

// 队列结构，用来存放二叉树结点指针
typedef struct
{
    BiTree elem[QUEUE_MAX_SIZE];    // 存放结点指针的数组
    int front;                      // 队头位置
    int rear;                       // 队尾位置
} LinkQueue;

// 函数声明
void InitQueue(LinkQueue *Q);
int IsQueueEmpty(LinkQueue Q);
int IsQueueFull(LinkQueue Q);
void EnQueue(LinkQueue *Q, BiTree node);
BiTree DeQueue(LinkQueue *Q);

BiTree CreateNode(char ch);
void CreateBiTreeByLevel(BiTree *T);
void LevelOrderTraverse(BiTree T);
void DestroyTree(BiTree T);

int main()
{
    BiTree T = NULL;

    printf("按层次顺序创建二叉树，输入 * 表示空结点。\n");

    CreateBiTreeByLevel(&T);

    printf("\n二叉树的层次遍历结果为：\n");
    LevelOrderTraverse(T);

    DestroyTree(T);

    return 0;
}

// 初始化队列
void InitQueue(LinkQueue *Q)
{
    Q->front = 0;
    Q->rear = 0;
}

// 判断队列是否为空
int IsQueueEmpty(LinkQueue Q)
{
    return Q.front == Q.rear;
}

// 判断队列是否已满
int IsQueueFull(LinkQueue Q)
{
    return (Q.rear + 1) % QUEUE_MAX_SIZE == Q.front;
}

// 入队操作
void EnQueue(LinkQueue *Q, BiTree node)
{
    if (IsQueueFull(*Q))
    {
        printf("队列已满，无法继续入队！\n");
        return;
    }

    Q->elem[Q->rear] = node;
    Q->rear = (Q->rear + 1) % QUEUE_MAX_SIZE;
}

// 出队操作
BiTree DeQueue(LinkQueue *Q)
{
    BiTree temp;

    if (IsQueueEmpty(*Q))
    {
        return NULL;
    }

    temp = Q->elem[Q->front];
    Q->front = (Q->front + 1) % QUEUE_MAX_SIZE;

    return temp;
}

// 创建一个新的二叉树结点
BiTree CreateNode(char ch)
{
    BiTree node = (BiTree)malloc(sizeof(TreeNode));

    if (node == NULL)
    {
        printf("内存分配失败！\n");
        exit(1);
    }

    node->data = ch;
    node->left = NULL;
    node->right = NULL;

    return node;
}

// 按层次顺序创建二叉树
void CreateBiTreeByLevel(BiTree *T)
{
    char ch;
    LinkQueue Q;
    BiTree current;
    BiTree newNode;

    InitQueue(&Q);

    printf("请输入根结点：");
    scanf(" %c", &ch);

    if (ch == '*')
    {
        *T = NULL;
        return;
    }

    // 创建根结点并入队
    *T = CreateNode(ch);
    EnQueue(&Q, *T);

    // 依次为队列中的每个结点输入左孩子和右孩子
    while (!IsQueueEmpty(Q))
    {
        current = DeQueue(&Q);

        printf("请输入 %c 的左孩子，* 表示空：", current->data);
        scanf(" %c", &ch);

        if (ch != '*')
        {
            newNode = CreateNode(ch);
            current->left = newNode;
            EnQueue(&Q, newNode);
        }

        printf("请输入 %c 的右孩子，* 表示空：", current->data);
        scanf(" %c", &ch);

        if (ch != '*')
        {
            newNode = CreateNode(ch);
            current->right = newNode;
            EnQueue(&Q, newNode);
        }
    }
}

// 二叉树的层次遍历，并按层分别输出
void LevelOrderTraverse(BiTree T)
{
    LinkQueue Q;
    BiTree current;

    if (T == NULL)
    {
        printf("该二叉树为空树。\n");
        return;
    }

    InitQueue(&Q);
    EnQueue(&Q, T);

    int level = 1;          // 当前层数
    int currentCount = 1;   // 当前层还未访问的结点数
    int nextCount = 0;      // 下一层的结点数

    printf("第%d层：", level);

    while (!IsQueueEmpty(Q))
    {
        current = DeQueue(&Q);

        printf("%c ", current->data);
        currentCount--;

        // 如果左孩子不为空，则左孩子入队
        if (current->left != NULL)
        {
            EnQueue(&Q, current->left);
            nextCount++;
        }

        // 如果右孩子不为空，则右孩子入队
        if (current->right != NULL)
        {
            EnQueue(&Q, current->right);
            nextCount++;
        }

        // 当前层访问完毕，换到下一层
        if (currentCount == 0 && nextCount > 0)
        {
            level++;
            printf("\n第%d层：", level);

            currentCount = nextCount;
            nextCount = 0;
        }
    }

    printf("\n");
}

// 释放二叉树占用的内存
void DestroyTree(BiTree T)
{
    if (T != NULL)
    {
        DestroyTree(T->left);
        DestroyTree(T->right);
        free(T);
    }
}