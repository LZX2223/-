#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "common.h"
#include "input.h"
#include "academic.h"
#include "student.h"

/*
 * student.c 是学生信息管理的核心业务模块。
 * 本文件把课堂上的多个数据结构组合起来使用：
 * 1. 学生单链表：保存所有学生的完整信息，方便动态插入和删除。
 * 2. 成绩链表：每个学生自己拥有一条成绩链表，解决课程数量不固定的问题。
 * 3. 哈希表：以学号为关键字，保存“学号 -> 学生结点地址”的映射，提高查找效率。
 * 4. 撤销栈：保存最近删除的学生副本，实现“撤销上一次删除”。
 * 5. 指针数组 + 快速排序：按平均成绩排名时只排序结点地址，不破坏原学生链表。
 */

/*
 * 学生链表头指针。
 * studentHead 永远指向学生单链表的第一个结点；没有学生时为 NULL。
 * 通过它可以遍历、显示、删除整个学生信息表。
 */
static StudentNode *studentHead = NULL;

/*
 * 学号哈希表。
 * hashTable 是一个指针数组，每个数组元素指向一条 HashNode 冲突链。
 * 哈希表只做索引，不保存完整学生数据；真实数据仍在 studentHead 管理的学生链表中。
 */
static HashNode *hashTable[HASH_SIZE] = {NULL};

/*
 * 撤销删除栈顶指针。
 * 删除学生前把学生副本压入 undoTop 指向的栈，撤销时从栈顶弹出。
 * 栈的后进先出特性保证最近删除的学生最先恢复。
 */
static UndoNode *undoTop = NULL;

/*
 * 当前学生总数。
 * 添加时加 1，删除时减 1。排序时可直接申请 studentCount 大小的数组，
 * 统计时也不需要每次重新遍历链表计数。
 */
static int studentCount = 0;

/* 以下 static 函数只在 student.c 内部使用，属于本模块的辅助函数。 */
static GradeNode *createGradeNode(char subject[], float score);
static void inputGrades(Student *s);
static void showOneStudent(Student s);
static float getAverageScore(Student s);

static unsigned int hashFunc(char id[]);
static void insertHash(char id[], StudentNode *ptr);
static void removeHash(char id[]);
static StudentNode *searchHash(char id[]);
static StudentNode *selectStudentForModify();
static StudentNode *selectStudentByIdForModify();
static StudentNode *selectStudentByNameForModify();
static int inputModifiedBasicInfo(Student *s);
static void showModifyFieldMenu();
static int modifyOneBasicField(Student *s, int choice);
static void copyBasicInfo(Student *dest, Student src);

static GradeNode *copyGrades(GradeNode *head);
static Student copyStudent(Student s);
static void pushUndo(Student s);
static void freeGrades(GradeNode *head);
static void freeStudent(Student s);

static void quickSort(StudentNode *arr[], int left, int right);

/*
 * 新增学生。
 * 核心流程：动态申请学生结点 -> 初始化指针 -> 录入学号 -> 用哈希表检查重复 ->
 * 录入成绩 -> 头插法插入学生链表 -> 同步插入哈希表。
 */
void addStudent()
{
    /* malloc 在堆区申请一个 StudentNode 结点，newNode 保存这个结点的地址。 */
    StudentNode *newNode = (StudentNode *)malloc(sizeof(StudentNode));

    if (newNode == NULL)
    {
        printf("内存申请失败！\n");
        return;
    }

    /*
     * 新结点刚创建时还没有课程成绩，也还没有接到学生链表中，
     * 所以成绩链表头指针 grades 和下一个学生指针 next 都先置为 NULL。
     */
    newNode->data.grades = NULL;
    newNode->next = NULL;

    /* 学号存入 newNode->data.id；data 是当前结点中保存的完整学生信息。 */
    readStudentId(newNode->data.id);

    /* 学号必须唯一，先通过哈希表查找，避免重复添加同一个学生。 */
    if (searchHash(newNode->data.id) != NULL)
    {
        printf("该学号已存在，添加失败！\n");
        /* 发现重复后不再使用这个新结点，必须释放，避免内存泄漏。 */
        free(newNode);
        return;
    }

  

    printf("\n开始录入课程成绩。\n");
    /* 传入学生信息的地址，inputGrades 可以直接修改该学生的成绩链表。 */
    inputGrades(&newNode->data);

    /*
     * 头插法插入学生链表：
     * 先让新结点指向原来的第一个学生，再让 studentHead 指向新结点。
     */
    newNode->next = studentHead;
    studentHead = newNode;
    studentCount++;

    /* 同步更新哈希表，建立“学号 -> 新学生结点地址”的快速查找索引。 */
    insertHash(newNode->data.id, newNode);

    printf("学生信息添加成功！\n");
}

/*
 * 循环录入某个学生的多门课程成绩，输入课程名 0 时结束。
 * 这里使用成绩链表，录入一门课程就创建一个 GradeNode，适合课程数量不固定的情况。
 */
static void inputGrades(Student *s)
{
    char subject[SUBJECT_LEN];
    float score;

    while (1)
    {
        readString("请输入科目名称，输入 0 结束成绩录入：", subject, SUBJECT_LEN);

        if (strcmp(subject, "0") == 0)
        {
            printf("成绩录入结束。\n");
            break;
        }

        char prompt[100];
        sprintf(prompt, "请输入 %s 的成绩：", subject);

        score = readFloatRange(prompt, 0, 100);

        GradeNode *newGrade = createGradeNode(subject, score);

        if (newGrade == NULL)
        {
            printf("成绩结点创建失败！\n");
            return;
        }

        /*
         * 头插法插入成绩链表：
         * newGrade 先指向原来的第一门成绩，再让学生的 grades 指向 newGrade。
         */
        newGrade->next = s->grades;
        s->grades = newGrade;

        printf("成绩录入成功！\n");
    }
}

/*
 * 创建单个成绩结点。
 * 返回值是 GradeNode *，也就是新成绩结点的地址；后续要靠这个地址接入成绩链表。
 */
static GradeNode *createGradeNode(char subject[], float score)
{
    GradeNode *node = (GradeNode *)malloc(sizeof(GradeNode));

    if (node == NULL)
    {
        return NULL;
    }

    strcpy(node->subject, subject);
    node->score = score;
    node->next = NULL;

    return node;
}

/* 遍历 studentHead 管理的学生单链表，并逐个显示学生信息。 */
void showStudents()
{
    if (studentHead == NULL)
    {
        printf("当前没有学生信息。\n");
        return;
    }

    StudentNode *p = studentHead;
    int index = 1;

    while (p != NULL)
    {
        printf("\n---------- 第 %d 个学生 ----------\n", index);
        showOneStudent(p->data);
        p = p->next;
        index++;
    }
}

/*
 * 显示单个学生的全部信息。
 * 基本信息直接从 Student 中读取；课程成绩需要遍历该学生自己的 GradeNode 成绩链表。
 */
static void showOneStudent(Student s)
{
    printf("学号：%s\n", s.id);
    printf("姓名：%s\n", s.name);
    printf("年龄：%d\n", s.age);
    printf("性别：%s\n", s.gender);
    printf("年级：%s\n", s.gradeYear);
    printf("学院：%s\n", s.college);
    printf("专业：%s\n", s.major);
    printf("班级：%s\n", s.className);
    printf("宿舍门牌号：%s\n", s.dorm);
    printf("手机号：%s\n", s.phone);

    if (s.grades == NULL)
    {
        printf("课程成绩：暂无\n");
    }
    else
    {
        printf("课程成绩：\n");

        GradeNode *g = s.grades;
        while (g != NULL)
        {
            printf("  %s：%.2f\n", g->subject, g->score);
            g = g->next;
        }

        printf("平均成绩：%.2f\n", getAverageScore(s));
    }
}

/*
 * 按学号查找学生。
 * 用户输入学号后，不直接遍历学生链表，而是调用 searchHash 在哈希表中查找。
 * 哈希表查找平均效率高于顺序遍历链表，是本系统的核心优化点之一。
 */
void searchStudent()
{
    char id[ID_LEN];

    readStudentId(id);

    StudentNode *result = searchHash(id);

    if (result == NULL)
    {
        printf("未找到该学生信息。\n");
    }
    else
    {
        printf("查找成功！\n");
        showOneStudent(result->data);
    }
}

/* 修改前按学号定位学生，返回学生链表结点指针；返回 NULL 表示取消或未找到。 */
static StudentNode *selectStudentByIdForModify()
{
    char id[100];

    while (1)
    {
        printf("请输入要修改学生的学号（12位数字，输入 0 取消）：");
        readLine(id, sizeof(id));

        if (strcmp(id, "0") == 0)
        {
            return NULL;
        }

        if (strlen(id) != 12 || !isAllDigits(id))
        {
            printf("输入错误！学号必须是 12 位数字。\n");
            continue;
        }

        StudentNode *target = searchHash(id);

        if (target == NULL)
        {
            printf("未找到该学生，无法修改！\n");
        }

        return target;
    }
}

/* 修改前按姓名查找学生；若有同名学生，则列出候选记录让用户进一步选择。 */
static StudentNode *selectStudentByNameForModify()
{
    char name[NAME_LEN];
    char temp[100];
    int count = 0;

    while (1)
    {
        printf("请输入要修改学生的姓名（输入 0 取消）：");
        readLine(temp, sizeof(temp));

        if (strcmp(temp, "0") == 0)
        {
            return NULL;
        }

        if (!isValidName(temp))
        {
            printf("输入错误！姓名不能为空，且不能包含数字。\n");
            continue;
        }

        strncpy(name, temp, NAME_LEN - 1);
        name[NAME_LEN - 1] = '\0';
        break;
    }

    StudentNode *p = studentHead;

    while (p != NULL)
    {
        if (strcmp(p->data.name, name) == 0)
        {
            count++;
        }

        p = p->next;
    }

    if (count == 0)
    {
        printf("未找到该姓名对应的学生，无法修改！\n");
        return NULL;
    }

    StudentNode **matches = (StudentNode **)malloc(sizeof(StudentNode *) * count);

    if (matches == NULL)
    {
        printf("内存申请失败，无法按姓名查找！\n");
        return NULL;
    }

    p = studentHead;
    int index = 0;

    while (p != NULL)
    {
        if (strcmp(p->data.name, name) == 0)
        {
            matches[index++] = p;
        }

        p = p->next;
    }

    if (count == 1)
    {
        StudentNode *target = matches[0];
        printf("已找到学生：%s，学号：%s。\n", target->data.name, target->data.id);
        free(matches);
        return target;
    }

    printf("找到多个同名学生，请选择要修改的记录：\n");

    for (int i = 0; i < count; i++)
    {
        Student *student = &matches[i]->data;

        printf("%d. 学号：%s，姓名：%s，学院：%s，专业：%s，班级：%s\n",
               i + 1,
               student->id,
               student->name,
               student->college,
               student->major,
               student->className);
    }

    int choice = readIntRange("请选择编号（输入 0 取消）：", 0, count);

    if (choice == 0)
    {
        free(matches);
        return NULL;
    }

    StudentNode *target = matches[choice - 1];
    free(matches);
    return target;
}

/* 选择修改时的查找方式，统一返回待修改学生结点。 */
static StudentNode *selectStudentForModify()
{
    int choice;

    printf("\n请选择查找方式：\n");
    printf("1. 按学号查找\n");
    printf("2. 按姓名查找\n");
    printf("0. 取消修改\n");

    choice = readIntRange("请输入选项：", 0, 2);

    if (choice == 0)
    {
        return NULL;
    }
    else if (choice == 1)
    {
        return selectStudentByIdForModify();
    }

    return selectStudentByNameForModify();
}

/* 一次性录入新的基本信息；任一字段取消都会使整个批量修改失败。 */
static int inputModifiedBasicInfo(Student *s)
{
    if (!readNameCancelable(s->name))
    {
        return 0;
    }

    s->age = readIntRange("请输入新的年龄（输入 0 取消）：", 0, 100);

    if (s->age == 0)
    {
        return 0;
    }

    if (!chooseGenderCancelable(s->gender))
    {
        return 0;
    }

    if (!chooseAcademicInfoCancelable(s))
    {
        return 0;
    }

    if (!readDormCancelable(s->dorm))
    {
        return 0;
    }

    if (!readPhoneCancelable(s->phone))
    {
        return 0;
    }

    return 1;
}

/* 显示基本信息修改菜单，8 表示确认保存暂存修改。 */
static void showModifyFieldMenu()
{
    printf("\n请选择要修改的信息：\n");
    printf("1. 姓名\n");
    printf("2. 年龄\n");
    printf("3. 性别\n");
    printf("4. 年级、学院、专业、班级\n");
    printf("5. 宿舍门牌号\n");
    printf("6. 手机号\n");
    printf("7. 修改全部基本信息\n");
    printf("8. 保存当前全部修改\n");
    printf("0. 取消并退出修改\n");
}

/* 根据菜单项修改暂存学生信息中的单个字段，返回 1 表示修改成功。 */
static int modifyOneBasicField(Student *s, int choice)
{
    Student temp = *s;

    switch (choice)
    {
    case 1:
        if (!readNameCancelable(temp.name))
        {
            return 0;
        }
        strcpy(s->name, temp.name);
        break;
    case 2:
        temp.age = readIntRange("请输入新的年龄（输入 0 取消）：", 0, 100);

        if (temp.age == 0)
        {
            return 0;
        }

        s->age = temp.age;
        break;
    case 3:
        if (!chooseGenderCancelable(temp.gender))
        {
            return 0;
        }
        strcpy(s->gender, temp.gender);
        break;
    case 4:
        if (!chooseAcademicInfoCancelable(&temp))
        {
            return 0;
        }
        strcpy(s->gradeYear, temp.gradeYear);
        strcpy(s->college, temp.college);
        strcpy(s->major, temp.major);
        strcpy(s->className, temp.className);
        break;
    case 5:
        if (!readDormCancelable(temp.dorm))
        {
            return 0;
        }
        strcpy(s->dorm, temp.dorm);
        break;
    case 6:
        if (!readPhoneCancelable(temp.phone))
        {
            return 0;
        }
        strcpy(s->phone, temp.phone);
        break;
    case 7:
        if (!inputModifiedBasicInfo(&temp))
        {
            return 0;
        }
        copyBasicInfo(s, temp);
        break;
    default:
        return 0;
    }

    return 1;
}
/* 只复制学生基本信息，不复制学号和成绩链表，避免修改时误改唯一标识或成绩数据。 */
static void copyBasicInfo(Student *dest, Student src)
{
    strcpy(dest->name, src.name);
    dest->age = src.age;
    strcpy(dest->gender, src.gender);
    strcpy(dest->gradeYear, src.gradeYear);
    strcpy(dest->college, src.college);
    strcpy(dest->major, src.major);
    strcpy(dest->className, src.className);
    strcpy(dest->dorm, src.dorm);
    strcpy(dest->phone, src.phone);
}

/*
 * 修改学生基本信息。
 * 先把真实学生信息复制到 temp 中，所有修改都先作用在 temp 上。
 * 只有用户选择“保存当前全部修改”时，才把 temp 写回真实结点，避免误操作直接破坏原数据。
 */
void modifyStudent()
{
    StudentNode *target = selectStudentForModify();
    Student temp;
    int choice;

    if (target == NULL)
    {
        printf("已取消修改学生基本信息。\n");
        return;
    }

    /* temp 是修改缓冲区，用户确认保存前不会影响原学生记录。 */
    temp = target->data;

    while (1)
    {
        printf("当前待保存的学生信息如下：\n");
        showOneStudent(temp);
        showModifyFieldMenu();

        choice = readIntRange("请输入选项：", 0, 8);

        if (choice == 0)
        {
            printf("已取消修改学生基本信息，原信息保持不变。\n");
            return;
        }

        if (choice == 8)
        {
            copyBasicInfo(&target->data, temp);
            printf("学生基本信息修改已保存！\n");
            return;
        }

        if (modifyOneBasicField(&temp, choice))
        {
            printf("本项信息已修改，按 8 保存后才会生效。\n");
        }
        else
        {
            printf("已取消本项修改，当前待保存信息保持不变。\n");
        }
    }
}
/*
 * 删除学生。
 * 先在学生链表中找到目标结点；删除前把学生完整副本压入撤销栈，保证可以恢复；
 * 然后断开链表连接、删除哈希表索引、释放该学生成绩链表和学生结点。
 */
void deleteStudent()
{
    char id[ID_LEN];

    readStudentId(id);

    StudentNode *cur = studentHead;
    StudentNode *pre = NULL;

    while (cur != NULL && strcmp(cur->data.id, id) != 0)
    {
        pre = cur;
        cur = cur->next;
    }

    if (cur == NULL)
    {
        printf("未找到该学生，无法删除！\n");
        return;
    }

    /* 删除前先压入撤销栈；pushUndo 内部会深拷贝成绩链表，避免后面 free 后数据丢失。 */
    pushUndo(cur->data);

    /*
     * 单链表删除分两种情况：
     * 1. pre 为 NULL，说明删除的是头结点，需要移动 studentHead。
     * 2. pre 不为 NULL，说明删除的是中间或尾部结点，让前驱结点跳过 cur。
     */
    if (pre == NULL)
    {
        studentHead = cur->next;
    }
    else
    {
        pre->next = cur->next;
    }

    /* 学生链表删掉后，也要同步删除哈希表索引，避免哈希表指向已经释放的结点。 */
    removeHash(id);
    /* 先释放该学生的成绩链表，再释放学生结点本身。 */
    freeGrades(cur->data.grades);
    free(cur);
    studentCount--;

    printf("学生信息删除成功！可以通过菜单 9 撤销本次删除。\n");
}

/* 给已有学生追加成绩，先按学号定位学生，再复用 inputGrades 录入多门课程。 */
void addGradeForStudent()
{
    char id[ID_LEN];

    readStudentId(id);

    StudentNode *target = searchHash(id);

    if (target == NULL)
    {
        printf("未找到该学生，无法添加成绩！\n");
        return;
    }

    printf("正在为学生 %s 添加课程成绩。\n", target->data.name);
    inputGrades(&target->data);
}

/*
 * 按平均成绩排序显示。
 * 链表不适合直接做快速排序，所以先把学生结点地址复制到指针数组 arr 中。
 * 排序时只交换指针，不移动或复制完整 Student 数据，也不改变原学生链表结构。
 */
void sortByAverageScore()
{
    if (studentCount == 0)
    {
        printf("当前没有学生信息，无法排序。\n");
        return;
    }

    StudentNode **arr = (StudentNode **)malloc(sizeof(StudentNode *) * studentCount);

    if (arr == NULL)
    {
        printf("排序数组申请失败！\n");
        return;
    }

    StudentNode *p = studentHead;
    int i = 0;

    while (p != NULL)
    {
        arr[i++] = p;
        p = p->next;
    }

    /* 只排序指针数组，原链表插入顺序保持不变；这也是“展示排序”和“存储结构”分离。 */
    quickSort(arr, 0, studentCount - 1);

    printf("\n按平均成绩从高到低排序结果：\n");

    for (i = 0; i < studentCount; i++)
    {
        printf("\n第 %d 名：\n", i + 1);
        showOneStudent(arr[i]->data);
    }

    free(arr);
}

/*
 * 快速排序：按平均成绩降序排列学生结点指针数组。
 * pivot 是基准平均分；左边放平均分较高的学生，右边放平均分较低的学生。
 */
static void quickSort(StudentNode *arr[], int left, int right)
{
    if (left >= right)
    {
        return;
    }

    int i = left;
    int j = right;
    float pivot = getAverageScore(arr[(left + right) / 2]->data);

    while (i <= j)
    {
        while (getAverageScore(arr[i]->data) > pivot)
        {
            i++;
        }

        while (getAverageScore(arr[j]->data) < pivot)
        {
            j--;
        }

        if (i <= j)
        {
            StudentNode *temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
            i++;
            j--;
        }
    }

    if (left < j)
    {
        quickSort(arr, left, j);
    }

    if (i < right)
    {
        quickSort(arr, i, right);
    }
}

/*
 * 成绩统计。
 * 遍历学生链表，逐个计算平均成绩，同时维护总平均分、最高平均分和最低平均分。
 */
void statistics()
{
    if (studentHead == NULL)
    {
        printf("当前没有学生信息，无法统计。\n");
        return;
    }

    StudentNode *p = studentHead;
    float sum = 0;
    float maxAvg = getAverageScore(p->data);
    float minAvg = getAverageScore(p->data);
    StudentNode *maxNode = p;
    StudentNode *minNode = p;

    while (p != NULL)
    {
        float avg = getAverageScore(p->data);
        sum += avg;

        if (avg > maxAvg)
        {
            maxAvg = avg;
            maxNode = p;
        }

        if (avg < minAvg)
        {
            minAvg = avg;
            minNode = p;
        }

        p = p->next;
    }

    printf("学生总人数：%d\n", studentCount);
    printf("全体学生平均成绩：%.2f\n", sum / studentCount);

    printf("平均成绩最高：%s，学号：%s，平均分：%.2f\n",
           maxNode->data.name,
           maxNode->data.id,
           maxAvg);

    printf("平均成绩最低：%s，学号：%s，平均分：%.2f\n",
           minNode->data.name,
           minNode->data.id,
           minAvg);
}

/*
 * 撤销删除。
 * 从 undoTop 弹出最近删除的学生副本，重新创建学生链表结点，
 * 再把它插回学生链表和哈希表。这里体现栈的“后进先出”。
 */
void undoDelete()
{
    if (undoTop == NULL)
    {
        printf("当前没有可撤销的删除操作。\n");
        return;
    }

    if (searchHash(undoTop->data.id) != NULL)
    {
        printf("该学号当前已存在，无法恢复。\n");
        return;
    }

    /* 出栈：temp 保存当前栈顶，undoTop 后移到下一条撤销记录。 */
    UndoNode *temp = undoTop;
    undoTop = undoTop->next;

    StudentNode *newNode = (StudentNode *)malloc(sizeof(StudentNode));

    if (newNode == NULL)
    {
        printf("恢复失败，内存不足！\n");
        freeStudent(temp->data);
        free(temp);
        return;
    }

    newNode->data = temp->data;
    /*
     * 头插法插入学生链表：
     * 先让新结点指向原来的第一个学生，再让 studentHead 指向新结点。
     */
    newNode->next = studentHead;
    studentHead = newNode;
    studentCount++;

    /* 同步更新哈希表，建立“学号 -> 新学生结点地址”的快速查找索引。 */
    insertHash(newNode->data.id, newNode);

    free(temp);

    printf("撤销删除成功，学生信息已恢复。\n");
}

/* 计算单个学生的平均成绩；没有成绩时按 0 分处理。 */
static float getAverageScore(Student s)
{
    GradeNode *p = s.grades;
    float sum = 0;
    int count = 0;

    while (p != NULL)
    {
        sum += p->score;
        count++;
        p = p->next;
    }

    if (count == 0)
    {
        return 0;
    }

    return sum / count;
}

/*
 * 字符串哈希函数。
 * 用 31 作为乘数逐字符累加，把 12 位学号字符串转换成一个整数，
 * 最后对 HASH_SIZE 取模，得到哈希表数组下标。
 */
static unsigned int hashFunc(char id[])
{
    unsigned int hash = 0;

    for (int i = 0; id[i] != '\0'; i++)
    {
        hash = hash * 31 + id[i];
    }

    return hash % HASH_SIZE;
}

/*
 * 将学号和学生链表结点地址插入哈希表。
 * 如果多个学号映射到同一个下标，就把新的 HashNode 插入该位置冲突链的表头，
 * 这就是哈希冲突处理中的链地址法。
 */
static void insertHash(char id[], StudentNode *ptr)
{
    unsigned int index = hashFunc(id);

    HashNode *node = (HashNode *)malloc(sizeof(HashNode));

    if (node == NULL)
    {
        printf("哈希表结点申请失败！\n");
        return;
    }

    strcpy(node->id, id);
    node->studentPtr = ptr;
    node->next = hashTable[index];
    hashTable[index] = node;
}

/*
 * 从哈希表中删除指定学号对应的哈希结点。
 * 删除学生时必须同步删除哈希索引，否则哈希表会保存一个无效的学生结点地址。
 */
static void removeHash(char id[])
{
    unsigned int index = hashFunc(id);

    HashNode *cur = hashTable[index];
    HashNode *pre = NULL;

    while (cur != NULL)
    {
        if (strcmp(cur->id, id) == 0)
        {
            if (pre == NULL)
            {
                hashTable[index] = cur->next;
            }
            else
            {
                pre->next = cur->next;
            }

            free(cur);
            return;
        }

        pre = cur;
        cur = cur->next;
    }
}

/*
 * 在哈希表中按学号查找。
 * 先用 hashFunc 计算下标，再遍历该下标处的冲突链；找到后返回学生链表结点指针。
 */
static StudentNode *searchHash(char id[])
{
    unsigned int index = hashFunc(id);

    HashNode *p = hashTable[index];

    while (p != NULL)
    {
        if (strcmp(p->id, id) == 0)
        {
            return p->studentPtr;
        }

        p = p->next;
    }

    return NULL;
}

/*
 * 深拷贝成绩链表。
 * 撤销删除必须保存独立副本，不能只复制 grades 指针。
 * 如果只复制指针，删除学生时成绩链表被 free 后，撤销栈里会留下悬空指针。
 */
static GradeNode *copyGrades(GradeNode *head)
{
    if (head == NULL)
    {
        return NULL;
    }

    GradeNode *newHead = NULL;
    GradeNode *tail = NULL;

    while (head != NULL)
    {
        GradeNode *newNode = createGradeNode(head->subject, head->score);

        if (newNode == NULL)
        {
            freeGrades(newHead);
            return NULL;
        }

        if (newHead == NULL)
        {
            newHead = newNode;
            tail = newNode;
        }
        else
        {
            tail->next = newNode;
            tail = newNode;
        }

        head = head->next;
    }

    return newHead;
}

/* 复制学生信息，并额外深拷贝成绩链表，供撤销删除保存完整学生副本。 */
static Student copyStudent(Student s)
{
    Student copy = s;
    copy.grades = copyGrades(s.grades);
    return copy;
}

/*
 * 把即将删除的学生压入撤销栈，供菜单 9 恢复。
 * 压栈采用头插法：新 UndoNode 指向原栈顶，再把 undoTop 改为新结点。
 */
static void pushUndo(Student s)
{
    UndoNode *node = (UndoNode *)malloc(sizeof(UndoNode));

    if (node == NULL)
    {
        printf("撤销栈空间不足，本次删除不可撤销。\n");
        return;
    }

    node->data = copyStudent(s);
    node->next = undoTop;
    undoTop = node;
}

/* 释放一条课程成绩链表：从头结点开始逐个 free，直到 NULL。 */
static void freeGrades(GradeNode *head)
{
    GradeNode *temp;

    while (head != NULL)
    {
        temp = head;
        head = head->next;
        free(temp);
    }
}

/* 释放学生结构中动态申请的部分，目前主要是成绩链表。 */
static void freeStudent(Student s)
{
    freeGrades(s.grades);
}

/*
 * 释放学生链表及每个学生的成绩链表。
 * 注意每个学生结点内部还有一条成绩链表，所以释放 StudentNode 前要先释放 grades。
 */
void freeAllStudents()
{
    StudentNode *cur = studentHead;
    StudentNode *temp;

    while (cur != NULL)
    {
        temp = cur;
        cur = cur->next;
        freeGrades(temp->data.grades);
        free(temp);
    }

    studentHead = NULL;
    studentCount = 0;
}

/*
 * 释放哈希表所有冲突链结点。
 * 哈希表只保存索引结点，学生本体由 freeAllStudents 释放，所以这里不释放 studentPtr 指向的数据。
 */
void freeHashTable()
{
    for (int i = 0; i < HASH_SIZE; i++)
    {
        HashNode *cur = hashTable[i];
        HashNode *temp;

        while (cur != NULL)
        {
            temp = cur;
            cur = cur->next;
            free(temp);
        }

        hashTable[i] = NULL;
    }
}

/* 释放撤销栈中的学生副本及其成绩链表，避免撤销记录占用动态内存。 */
void freeUndoStack()
{
    UndoNode *cur = undoTop;
    UndoNode *temp;

    while (cur != NULL)
    {
        temp = cur;
        cur = cur->next;
        freeStudent(temp->data);
        free(temp);
    }

    undoTop = NULL;
}