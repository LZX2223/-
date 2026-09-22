#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#ifndef _Queue_h

struct QueueRecord;
typedef struct QueueRecord* Queue;

Queue CreateQueue(int MaxQueueSize);
int isEmpty(Queue Q);
int isFull(Queue Q);
void Enqueue(Queue Q, int X);
void Dequeue(Queue Q);
void Display(Queue Q);
void MakeEmpty(Queue Q);

#endif // !_Queue_h

#define MinQueueSize 3

struct QueueRecord
{
    int Capacity;
    int Front;
    int Rear;
    int Size;
    int* Array;
};

int main()
{
    //初始化队列
    Queue Q = NULL;
    int MaxQueueSize = 0;
    while (Q == NULL) 
    {
        printf("输入创建的队列的容积：");
        scanf_s("%d", &MaxQueueSize);
        Q = CreateQueue(MaxQueueSize);
        if (Q) 
        {
            printf("生成成功。\n");
            break;
        }
    }
    //向队列中存入数字
    int num = 0;
    int n = 0;
    while (Q) 
    {
        printf("指令1实现入队，指令2实现出队；\n");
        scanf_s("%d", &n);

        if (n == 1) 
        {
            printf("输入入列数字:");
            scanf_s("%d", &num);
            Enqueue(Q, num);
            Display(Q);
        }
        else if (n == 2) 
        {
            if (isEmpty(Q))
                printf("队列为空。\n");
            else 
            {
                Dequeue(Q);
                if (isEmpty(Q))
                    printf("队列为空。\n");
                else
                    Display(Q);
            }
        }
    }
    return 0;
}

//生成队列
Queue CreateQueue(int MaxQueueSize)
{
    Queue Q;
    if (MaxQueueSize >= MinQueueSize) 
    {
        Q = (Queue)malloc(sizeof(struct QueueRecord));
        if (Q) 
        {
            Q->Array = (int*)malloc(sizeof(int) * MaxQueueSize);
            Q->Capacity = MaxQueueSize;
            MakeEmpty(Q);
            return Q;
        }
        else 
        {
            printf("创建失败。");
            return 0;
        }
    }
    else 
    {
        printf("容积过小，生成失败。\n");
        return 0;
    }
}

//创建一个空队列
void MakeEmpty(Queue Q)
{
    Q->Size = 0;
    Q->Front = 0;
    Q->Rear = 0;
}

//检测队列是否为空
int isEmpty(Queue Q)
{
    return Q->Size == 0;
}

//检测队列是否已满
int isFull(Queue Q)
{
    return Q->Size == Q->Capacity;
}

//入列
void Enqueue(Queue Q, int X)
{
    if (isFull(Q))
        printf("队列已满。\n");
    else {
        if (Q->Rear == Q->Capacity)
            Q->Rear = 0;
        Q->Array[Q->Rear] = X;
        Q->Rear++;
        Q->Size++;
    }
}

//出列
void Dequeue(Queue Q)
{
    if (isEmpty(Q))
        printf("队列为空。\n");
    else {
        if (Q->Front == Q->Capacity)
            Q->Front = 0;
        Q->Front++;
        Q->Size--;
    }
}

//输出队列
void Display(Queue Q)
{
    int i = 0;
    printf("队列中的数据：");
    if (Q->Front < Q->Rear)
        for (i = Q->Front; i < Q->Rear; i++)
            printf("%d ", Q->Array[i]);
    else if (Q->Front >= Q->Rear) {
        for (i = Q->Front; i < Q->Capacity; i++)
            printf("%d ", Q->Array[i]);
        for (i = 0; i < Q->Rear; i++)
            printf("%d ", Q->Array[i]);
    }
    printf("\n");
}

