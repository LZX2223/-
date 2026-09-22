#include <stdio.h>
#include <stdlib.h>

/* 二叉排序树结点定义 */
typedef struct BSTNode
{
    int data;
    struct BSTNode *left;
    struct BSTNode *right;
} BSTNode, *BSTree;

/* 队列结点定义，用于按层输出二叉排序树结构 */
typedef struct QueueNode
{
    BSTree treeNode;
    struct QueueNode *next;
} QueueNode;

/* 链式队列定义 */
typedef struct LinkQueue
{
    QueueNode *front;
    QueueNode *rear;
} LinkQueue;

/* 函数声明 */
BSTree NewTreeNode(int data);
BSTree InsertBST(BSTree root, int data);
int SearchBST(BSTree root, int key);
BSTree InsertIfAbsent(BSTree root, int key);

void PrintIncreasing(BSTree root);
void PrintDecreasing(BSTree root);
void PrintLevelOrder(BSTree root);
void DestroyTree(BSTree root);

LinkQueue *InitQueue(void);
int QueueIsEmpty(LinkQueue *Q);
void EnQueue(LinkQueue *Q, BSTree node);
BSTree DeQueue(LinkQueue *Q);
void DestroyQueue(LinkQueue *Q);

int main()
{
    int T;

    printf("请输入测试数据组数 T：");
    scanf("%d", &T);

    for (int group = 1; group <= T; group++)
    {
        int n;
        int value;
        int key;
        BSTree root = NULL;

        printf("\n第 %d 组数据\n", group);

        printf("请输入结点个数 n：");
        scanf("%d", &n);

        if (n < 5 || n > 20)
        {
            printf("输入的 n 不符合要求，n 应满足 5 <= n <= 20。\n");
            continue;
        }

        printf("请输入 %d 个整数：", n);

        for (int i = 0; i < n; i++)
        {
            scanf("%d", &value);
            root = InsertBST(root, value);
        }

        printf("\n二叉排序树的层次结构为：\n");
        PrintLevelOrder(root);

        printf("\n递增顺序输出：");
        PrintIncreasing(root);
        printf("\n");

        printf("请输入要查找的 key：");
        scanf("%d", &key);

        if (SearchBST(root, key))
        {
            printf("find\n");
        }
        else
        {
            printf("not find\n");
        }

        printf("请输入要插入的 key：");
        scanf("%d", &key);

        if (SearchBST(root, key))
        {
            printf("该结点已经存在，不执行插入操作。\n");
        }
        else
        {
            root = InsertBST(root, key);
            printf("插入成功。\n");
        }

        printf("插入后的层次结构为：\n");
        PrintLevelOrder(root);

        printf("\n递减顺序输出：");
        PrintDecreasing(root);
        printf("\n");

        DestroyTree(root);
    }

    return 0;
}

/* 创建新结点 */
BSTree NewTreeNode(int data)
{
    BSTree node = (BSTree)malloc(sizeof(BSTNode));

    if (node == NULL)
    {
        printf("内存申请失败！\n");
        exit(1);
    }

    node->data = data;
    node->left = NULL;
    node->right = NULL;

    return node;
}

/* 向二叉排序树中插入结点 */
BSTree InsertBST(BSTree root, int data)
{
    if (root == NULL)
    {
        return NewTreeNode(data);
    }

    if (data < root->data)
    {
        root->left = InsertBST(root->left, data);
    }
    else if (data > root->data)
    {
        root->right = InsertBST(root->right, data);
    }
    else
    {
        /* 重复数据不插入 */
        return root;
    }

    return root;
}

/* 查找指定 key 是否存在 */
int SearchBST(BSTree root, int key)
{
    if (root == NULL)
    {
        return 0;
    }

    if (key == root->data)
    {
        return 1;
    }
    else if (key < root->data)
    {
        return SearchBST(root->left, key);
    }
    else
    {
        return SearchBST(root->right, key);
    }
}

/* 如果 key 不存在，则插入 */
BSTree InsertIfAbsent(BSTree root, int key)
{
    if (!SearchBST(root, key))
    {
        root = InsertBST(root, key);
    }

    return root;
}

/* 中序遍历：递增输出 */
void PrintIncreasing(BSTree root)
{
    if (root == NULL)
    {
        return;
    }

    PrintIncreasing(root->left);
    printf("%d ", root->data);
    PrintIncreasing(root->right);
}

/* 反向中序遍历：递减输出 */
void PrintDecreasing(BSTree root)
{
    if (root == NULL)
    {
        return;
    }

    PrintDecreasing(root->right);
    printf("%d ", root->data);
    PrintDecreasing(root->left);
}

/* 初始化链式队列 */
LinkQueue *InitQueue(void)
{
    LinkQueue *Q = (LinkQueue *)malloc(sizeof(LinkQueue));

    if (Q == NULL)
    {
        printf("队列创建失败！\n");
        exit(1);
    }

    Q->front = NULL;
    Q->rear = NULL;

    return Q;
}

/* 判断队列是否为空 */
int QueueIsEmpty(LinkQueue *Q)
{
    return Q->front == NULL;
}

/* 入队 */
void EnQueue(LinkQueue *Q, BSTree node)
{
    QueueNode *newNode = (QueueNode *)malloc(sizeof(QueueNode));

    if (newNode == NULL)
    {
        printf("队列结点申请失败！\n");
        exit(1);
    }

    newNode->treeNode = node;
    newNode->next = NULL;

    if (Q->rear == NULL)
    {
        Q->front = newNode;
        Q->rear = newNode;
    }
    else
    {
        Q->rear->next = newNode;
        Q->rear = newNode;
    }
}

/* 出队 */
BSTree DeQueue(LinkQueue *Q)
{
    QueueNode *temp;
    BSTree node;

    if (QueueIsEmpty(Q))
    {
        return NULL;
    }

    temp = Q->front;
    node = temp->treeNode;

    Q->front = Q->front->next;

    if (Q->front == NULL)
    {
        Q->rear = NULL;
    }

    free(temp);

    return node;
}

/* 释放队列 */
void DestroyQueue(LinkQueue *Q)
{
    while (!QueueIsEmpty(Q))
    {
        DeQueue(Q);
    }

    free(Q);
}

/* 按层次输出二叉排序树结构 */
void PrintLevelOrder(BSTree root)
{
    if (root == NULL)
    {
        printf("当前二叉排序树为空。\n");
        return;
    }

    LinkQueue *Q = InitQueue();

    EnQueue(Q, root);

    int level = 1;
    int currentCount = 1;
    int nextCount = 0;

    printf("第%d层：", level);

    while (!QueueIsEmpty(Q))
    {
        BSTree current = DeQueue(Q);

        printf("%d ", current->data);
        currentCount--;

        if (current->left != NULL)
        {
            EnQueue(Q, current->left);
            nextCount++;
        }

        if (current->right != NULL)
        {
            EnQueue(Q, current->right);
            nextCount++;
        }

        if (currentCount == 0 && nextCount > 0)
        {
            level++;
            printf("\n第%d层：", level);
            currentCount = nextCount;
            nextCount = 0;
        }
    }

    printf("\n");

    DestroyQueue(Q);
}

/* 释放二叉排序树 */
void DestroyTree(BSTree root)
{
    if (root != NULL)
    {
        DestroyTree(root->left);
        DestroyTree(root->right);
        free(root);
    }
}