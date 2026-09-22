#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXSIZE 100

typedef char ElemType[50];

typedef struct Node {
    ElemType data;
    struct Node *next;
} Node, *LinkList;


/* 初始化线性表 */
void InitList(LinkList *L) {
    *L = (LinkList)malloc(sizeof(Node));
    if (*L == NULL) {
        printf("初始化失败，内存不足！\n");
        exit(1);
    }
    (*L)->next = NULL;
}


/* 判断线性表是否为空 */
int IsEmpty(LinkList L) {
    if (L->next == NULL) {
        return 1;
    }
    return 0;
}


/* 求线性表长度 */
int GetLength(LinkList L) {
    int count = 0;
    Node *p = L->next;

    while (p != NULL) {
        count++;
        p = p->next;
    }

    return count;
}


/* 取出第 i 个元素 */
int GetElem(LinkList L, int i, ElemType e) {
    int j = 1;
    Node *p = L->next;

    if (i < 1) {
        return 0;
    }

    while (p != NULL && j < i) {
        p = p->next;
        j++;
    }

    if (p == NULL) {
        return 0;
    }

    strcpy(e, p->data);
    return 1;
}


/* 在第 i 个位置插入元素 */
int InsertElem(LinkList L, int i, const char *e) {
    int j = 0;
    Node *p = L;
    Node *s = NULL;

    if (i < 1) {
        return 0;
    }

    while (p != NULL && j < i - 1) {
        p = p->next;
        j++;
    }

    if (p == NULL) {
        return 0;
    }

    s = (Node *)malloc(sizeof(Node));
    if (s == NULL) {
        printf("插入失败，内存不足！\n");
        exit(1);
    }

    strncpy(s->data, e, 49);
    s->data[49] = '\0';

    s->next = p->next;
    p->next = s;

    return 1;
}


/* 删除第 i 个元素 */
int DeleteElem(LinkList L, int i, ElemType e) {
    int j = 0;
    Node *p = L;
    Node *q = NULL;

    if (i < 1) {
        return 0;
    }

    while (p->next != NULL && j < i - 1) {
        p = p->next;
        j++;
    }

    if (p->next == NULL) {
        return 0;
    }

    q = p->next;
    p->next = q->next;

    strcpy(e, q->data);
    free(q);

    return 1;
}


/* 输出线性表 */
void PrintList(LinkList L) {
    int i = 1;
    Node *p = L->next;

    if (IsEmpty(L)) {
        printf("\n当前线性表为空。\n");
        return;
    }

    printf("\n当前线性表内容为：\n");

    while (p != NULL) {
        printf("第 %d 个元素：%s\n", i, p->data);
        p = p->next;
        i++;
    }
}


/* 销毁线性表 */
void DestroyList(LinkList *L) {
    Node *p = NULL;
    Node *q = NULL;

    if (*L == NULL) {
        return;
    }

    p = *L;

    while (p != NULL) {
        q = p->next;
        free(p);
        p = q;
    }

    *L = NULL;
}


/* 创建初始线性表 */
void CreateList(LinkList L) {
    int n;
    int i;
    char value[50];

    printf("请输入需要建立的元素个数：");
    scanf("%d", &n);

    if (n < 0) {
        printf("元素个数不能为负数，已自动设置为 0。\n");
        n = 0;
    }

    for (i = 1; i <= n; i++) {
        printf("请输入第 %d 个元素的值：", i);
        scanf("%49s", value);
        InsertElem(L, i, value);
    }
}


/* 菜单 */
void Menu(void) {
    
    printf("1. 判断线性表是否为空\n");
    printf("2. 求线性表长度\n");
    printf("3. 取第 i 个元素\n");
    printf("4. 在第 i 个位置插入元素\n");
    printf("5. 删除第 i 个元素\n");
    printf("6. 输出线性表\n");
    printf("0. 退出程序\n");
    printf("==============================\n");
    printf("请输入操作编号：");
}


int main(void) {
    LinkList L;
    int choice;
    int pos;
    char value[50];
    char deleted[50];

    InitList(&L);
    CreateList(L);

    do {
        Menu();
        scanf("%d", &choice);

        switch (choice) {
        case 1:
            if (IsEmpty(L)) {
                printf("结果：该线性表为空。\n");
            } else {
                printf("结果：该线性表不为空。\n");
            }
            break;

        case 2:
            printf("当前线性表长度为：%d\n", GetLength(L));
            break;

        case 3:
            printf("请输入要查询的位置 i：");
            scanf("%d", &pos);

            if (GetElem(L, pos, value)) {
                printf("查询结果：第 %d 个元素是 %s。\n", pos, value);
            } else {
                printf("查询失败：输入的位置不合法。\n");
            }
            break;

        case 4:
            printf("请输入插入位置 i：");
            scanf("%d", &pos);

            printf("请输入新元素的值：");
            scanf("%49s", value);

            if (InsertElem(L, pos, value)) {
                printf("插入完成。\n");
            } else {
                printf("插入失败：输入的位置不合法。\n");
            }
            break;

        case 5:
            printf("请输入删除位置 i：");
            scanf("%d", &pos);

            if (DeleteElem(L, pos, deleted)) {
                printf("删除完成，被删除的元素为：%s。\n", deleted);
            } else {
                printf("删除失败：输入的位置不合法。\n");
            }
            break;

        case 6:
            PrintList(L);
            break;

        case 0:
            printf("已退出 ADT 表操作程序。\n");
            break;

        default:
            printf("输入错误，请重新选择。\n");
            break;
        }

    } while (choice != 0);

    DestroyList(&L);

    return 0;
}