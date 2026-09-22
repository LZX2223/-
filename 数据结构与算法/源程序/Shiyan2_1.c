#include <stdio.h>
#include <stdlib.h>

#define MIN_STACK_SIZE 5
#define EMPTY_TOP -1

// 定义栈结构体
typedef struct StackNode
{
    int capacity;   // 栈的最大容量
    int top;        // 栈顶下标
    int *data;      // 用数组存储栈元素
} *Stack;

// 函数声明
Stack InitStack(int size);
int IsEmpty(Stack S);
int IsFull(Stack S);
void Push(Stack S, int x);
void Pop(Stack S);
void PrintStack(Stack S);
void ClearStack(Stack S);
void DestroyStack(Stack S);

int main()
{
    int size;
    Stack S = NULL;

    // 创建栈
    while (S == NULL)
    {
        printf("请输入栈的容量：");
        scanf("%d", &size);

        S = InitStack(size);

        if (S == NULL)
        {
            printf("栈创建失败，请重新输入容量！\n");
        }
    }

    printf("栈创建成功！\n");

    int choice;
    int value;

    while (1)
    {
        printf("\n========== 栈的基本操作 ==========\n");
        printf("1. Push 入栈\n");
        printf("2. Pop 出栈\n");
        printf("3. 显示栈中元素\n");
        printf("0. 退出程序\n");
        printf("请选择操作：");
        scanf("%d", &choice);

        switch (choice)
        {
        case 1:
            printf("请输入要入栈的数据：");
            scanf("%d", &value);
            Push(S, value);
            PrintStack(S);
            break;

        case 2:
            Pop(S);
            PrintStack(S);
            break;

        case 3:
            PrintStack(S);
            break;

        case 0:
            DestroyStack(S);
            printf("程序结束，栈空间已释放。\n");
            return 0;

        default:
            printf("输入有误，请重新选择！\n");
        }
    }
}

// 生成栈
Stack InitStack(int size)
{
    Stack S;

    // 判断输入容量是否合法
    if (size < MIN_STACK_SIZE)
    {
        printf("栈容量不能小于 %d！\n", MIN_STACK_SIZE);
        return NULL;
    }

    // 给栈结构体分配内存
    S = (Stack)malloc(sizeof(struct StackNode));
    if (S == NULL)
    {
        printf("结构体空间申请失败！\n");
        return NULL;
    }

    // 给数组分配内存
    S->data = (int *)malloc(sizeof(int) * size);
    if (S->data == NULL)
    {
        printf("数组空间申请失败！\n");
        free(S);
        return NULL;
    }

    S->capacity = size;
    S->top = EMPTY_TOP;

    return S;
}

// 判断栈是否为空
int IsEmpty(Stack S)
{
    return S->top == EMPTY_TOP;
}

// 判断栈是否已满
int IsFull(Stack S)
{
    return S->top == S->capacity - 1;
}

// Push：入栈操作
void Push(Stack S, int x)
{
    if (IsFull(S))
    {
        printf("栈已满，无法继续入栈！\n");
        return;
    }

    S->top++;
    S->data[S->top] = x;

    printf("元素 %d 入栈成功。\n", x);
}

// Pop：出栈操作
void Pop(Stack S)
{
    if (IsEmpty(S))
    {
        printf("当前栈为空，无法出栈！\n");
        return;
    }

    printf("出栈元素为：%d\n", S->data[S->top]);
    S->top--;
}

// 输出栈中元素
void PrintStack(Stack S)
{
    if (IsEmpty(S))
    {
        printf("当前栈为空。\n");
        return;
    }

    printf("当前栈中元素为：");

    for (int i = 0; i <= S->top; i++)
    {
        printf("%d ", S->data[i]);
    }

    printf("\n");
}

// 清空栈
void ClearStack(Stack S)
{
    S->top = EMPTY_TOP;
}

// 销毁栈，释放内存
void DestroyStack(Stack S)
{
    if (S != NULL)
    {
        free(S->data);
        free(S);
    }
}