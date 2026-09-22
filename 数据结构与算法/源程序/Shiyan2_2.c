#include <stdio.h>
#include <stdlib.h>

#define MIN_QUEUE_SIZE 3

// 定义队列结构体
typedef struct QueueNode
{
    int capacity;   // 队列最大容量
    int front;      // 队头位置
    int rear;       // 队尾位置
    int size;       // 当前队列中元素个数
    int *data;      // 存放队列元素的数组
} *Queue;

// 函数声明
Queue InitQueue(int maxSize);
void ClearQueue(Queue Q);
int QueueEmpty(Queue Q);
int QueueFull(Queue Q);
void EnQueue(Queue Q, int x);
void DeQueue(Queue Q);
void PrintQueue(Queue Q);
void DestroyQueue(Queue Q);

int main()
{
    Queue Q = NULL;
    int maxSize;

    // 创建队列
    while (Q == NULL)
    {
        printf("请输入队列的容量：");
        scanf("%d", &maxSize);

        Q = InitQueue(maxSize);

        if (Q == NULL)
        {
            printf("队列创建失败，请重新输入！\n");
        }
    }

    printf("队列创建成功！\n");

    int choice;
    int value;

    while (1)
    {
        printf("\n==================\n");
        printf("1. 入队\n");
        printf("2. 出队\n");
        printf("3. 显示队列\n");
        printf("0. 退出程序\n");
        printf("请选择操作：");
        scanf("%d", &choice);

        switch (choice)
        {
        case 1:
            printf("请输入要入队的数据：");
            scanf("%d", &value);
            EnQueue(Q, value);
            PrintQueue(Q);
            break;

        case 2:
            DeQueue(Q);
            PrintQueue(Q);
            break;

        case 3:
            PrintQueue(Q);
            break;

        case 0:
            DestroyQueue(Q);
            printf("程序结束，队列空间已释放。\n");
            return 0;

        default:
            printf("输入有误，请重新选择！\n");
            break;
        }
    }
}

// 创建队列
Queue InitQueue(int maxSize)
{
    Queue Q;

    if (maxSize < MIN_QUEUE_SIZE)
    {
        printf("队列容量不能小于 %d！\n", MIN_QUEUE_SIZE);
        return NULL;
    }

    // 为队列结构体申请空间
    Q = (Queue)malloc(sizeof(struct QueueNode));
    if (Q == NULL)
    {
        printf("队列结构体空间申请失败！\n");
        return NULL;
    }

    // 为数组申请空间
    Q->data = (int *)malloc(sizeof(int) * maxSize);
    if (Q->data == NULL)
    {
        printf("队列数组空间申请失败！\n");
        free(Q);
        return NULL;
    }

    Q->capacity = maxSize;
    ClearQueue(Q);

    return Q;
}

// 初始化为空队列
void ClearQueue(Queue Q)
{
    Q->front = 0;
    Q->rear = 0;
    Q->size = 0;
}

// 判断队列是否为空
int QueueEmpty(Queue Q)
{
    return Q->size == 0;
}

// 判断队列是否已满
int QueueFull(Queue Q)
{
    return Q->size == Q->capacity;
}

// 入队操作
void EnQueue(Queue Q, int x)
{
    if (QueueFull(Q))
    {
        printf("队列已满，无法入队！\n");
        return;
    }

    Q->data[Q->rear] = x;

    // rear 后移一位，若到达数组末尾则回到 0，实现循环队列
    Q->rear = (Q->rear + 1) % Q->capacity;

    Q->size++;

    printf("元素 %d 入队成功。\n", x);
}

// 出队操作
void DeQueue(Queue Q)
{
    if (QueueEmpty(Q))
    {
        printf("当前队列为空，无法出队！\n");
        return;
    }

    printf("出队元素为：%d\n", Q->data[Q->front]);

    // front 后移一位，若到达数组末尾则回到 0
    Q->front = (Q->front + 1) % Q->capacity;

    Q->size--;
}

// 显示队列中的元素
void PrintQueue(Queue Q)
{
    if (QueueEmpty(Q))
    {
        printf("当前队列为空。\n");
        return;
    }

    printf("当前队列中的元素为：");

    for (int i = 0; i < Q->size; i++)
    {
        int index = (Q->front + i) % Q->capacity;
        printf("%d ", Q->data[index]);
    }

    printf("\n");
}

// 销毁队列，释放内存
void DestroyQueue(Queue Q)
{
    if (Q != NULL)
    {
        free(Q->data);
        free(Q);
    }
}