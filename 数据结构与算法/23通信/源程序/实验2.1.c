#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef _Stack_h

// 先声明结构体 StackRecord
struct StackRecord;

// 将 struct StackRecord* 重命名为 Stack
// 以后 Stack 就表示指向栈结构体的指针
typedef struct StackRecord* Stack;

// 判断栈是否为空
int isEmpty(Stack S);

// 判断栈是否已满
int isFull(Stack S);

// 创建一个指定容量的栈
Stack CreateStack(int MaxElements);

// 将栈置空
void MakeEmpty(Stack S);

// 入栈操作，将元素 X 压入栈 S
void Push(int X, Stack S);

// 出栈操作，删除栈顶元素
void Pop(Stack S);

// 显示栈中的所有元素
void Display(Stack S);

// 释放栈所占用的内存
void DisposeStack(Stack S);

#endif

// 空栈时栈顶下标定义为 -1
#define EmptyTOS -1

// 栈的最小容量
#define MinStackSize 5

// 栈的结构体定义
struct StackRecord
{
    int Capacity;      // 栈的最大容量
    int TopOfStack;   // 栈顶元素的下标
    int* Array;       // 用数组存储栈中的元素
};

int main()
{
    // 初始化一个空栈指针
    Stack S = NULL;

    // 用于保存用户输入的栈容量
    int MaxElement = 0;

    // 循环创建栈，直到创建成功为止
    while (S == NULL)
    {
        printf("请输入创建栈的容量：");
        scanf("%d", &MaxElement);

        // 根据用户输入的容量创建栈
        S = CreateStack(MaxElement);

        // 如果创建成功，输出提示信息并跳出循环
        if (S)
        {
            printf("创建完成！\n");
            break;
        }
    }

    // 用于保存用户选择的操作编号
    int n = 0;

    // 只要栈存在，就循环执行菜单操作
    while (S)
    {
        printf("输入 1 可存入数据，输入 2 可弹出数据：\n");
        scanf("%d", &n);

        if (n == 1) // 向栈中压入数据
        {
            printf("请输入要压入的数据个数：");

            int sum = 0; // 要压入的数据个数
            int num = 0; // 每次输入的具体数据

            scanf("%d", &sum);

            // 循环输入多个数据并依次压入栈中
            for (int i = 0; i < sum; i++)
            {
                printf("压栈的第 %d 个数据为：", i + 1);
                scanf("%d", &num);

                // 将输入的数据压入栈
                Push(num, S);
            }

            // 显示当前栈中的所有元素
            Display(S);

            // 重置操作编号
            n = 0;
        }
        else if (n == 2) // 出栈操作
        {
            // 弹出栈顶元素
            Pop(S);

            // 显示出栈后的栈中元素
            Display(S);
        }
    }
}

// 通过数组实现栈的创建
Stack CreateStack(int MaxElements)
{
    Stack S;

    // 判断栈容量是否满足最小要求
    if (MaxElements >= MinStackSize)
    {
        // 为栈结构体分配内存空间
        S = (Stack)malloc(sizeof(struct StackRecord));

        if (S)
        {
            // 为存放栈元素的数组分配内存空间
            S->Array = (int*)malloc(sizeof(int) * MaxElements);

            // 设置栈的容量
            S->Capacity = MaxElements;

            // 初始化为空栈
            MakeEmpty(S);

            // 返回创建好的栈
            return S;
        }
        else
        {
            printf("栈创建失败！\n");
            return 0;
        }
    }
    else
    {
        printf("栈容量太小，创建失败！\n");
        return 0;
    }
}

// 将栈置为空栈
void MakeEmpty(Stack S)
{
    // 空栈时，栈顶下标设置为 -1
    S->TopOfStack = EmptyTOS;
}

// 入栈操作
void Push(int X, Stack S)
{
    // 如果栈已满，则不能继续压入数据
    if (isFull(S))
        printf("栈已满，无法继续压栈！\n");
    else
    {
        // 栈顶指针向上移动一位
        S->TopOfStack++;

        // 将新元素放入栈顶位置
        S->Array[S->TopOfStack] = X;
    }
}

// 出栈操作
void Pop(Stack S)
{
    // 如果栈为空，则不能出栈
    if (isEmpty(S))
        printf("当前为空栈，无法出栈！\n");
    else
    {
        // 输出当前栈顶元素
        printf("弹出的数据为：%d\n", S->Array[S->TopOfStack]);

        // 栈顶指针下移，相当于删除栈顶元素
        S->TopOfStack--;
    }
}

// 判断栈是否为空
int isEmpty(Stack S)
{
    // 如果栈顶下标为 -1，说明栈为空
    return S->TopOfStack == EmptyTOS;
}

// 判断栈是否已满
int isFull(Stack S)
{
    // 如果栈顶下标等于容量 - 1，说明栈已满
    return S->TopOfStack == S->Capacity - 1;
}

// 显示栈中的所有元素
void Display(Stack S)
{
    // 如果栈为空，输出提示信息
    if (isEmpty(S))
        printf("当前为空栈！\n");
    else
    {
        printf("栈中数据为：");

        // 从栈底到栈顶依次输出元素
        for (int i = 0; i <= S->TopOfStack; i++)
            printf("%d ", S->Array[i]);

        printf("\n");
    }
}