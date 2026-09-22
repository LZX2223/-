#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define ID_LEN 13
#define NAME_LEN 30
#define MAJOR_LEN 50
#define GRADE_LEN 20
#define GENDER_LEN 10
#define DORM_LEN 30
#define PHONE_LEN 12
#define SUBJECT_LEN 30
#define HASH_SIZE 101

typedef struct GradeNode
{
    char subject[SUBJECT_LEN];
    float score;
    struct GradeNode *next;
} GradeNode;

typedef struct Student
{
    char id[ID_LEN];              // 学号，固定 12 位数字
    char name[NAME_LEN];          // 姓名
    int age;                      // 年龄
    char gender[GENDER_LEN];      // 性别
    char major[MAJOR_LEN];        // 专业
    char gradeYear[GRADE_LEN];    // 年级
    char dorm[DORM_LEN];          // 宿舍门牌号
    char phone[PHONE_LEN];        // 手机号，11 位数字
    GradeNode *grades;            // 课程成绩链表
} Student;

typedef struct StudentNode
{
    Student data;
    struct StudentNode *next;
} StudentNode;

typedef struct HashNode
{
    char id[ID_LEN];
    StudentNode *studentPtr;
    struct HashNode *next;
} HashNode;

typedef struct UndoNode
{
    Student data;
    struct UndoNode *next;
} UndoNode;

StudentNode *studentHead = NULL;
HashNode *hashTable[HASH_SIZE] = {NULL};
UndoNode *undoTop = NULL;
int studentCount = 0;

/* 输入检查函数 */
void readLine(char *buffer, int size);
int readInt(const char *prompt);
float readFloat(const char *prompt, float min, float max);
void readString(const char *prompt, char *buffer, int size);

void readStudentId(char *id);
void readPhone(char *phone);
void readName(char *name);
void readDorm(char *dorm);
void chooseGender(char *gender);
void chooseGrade(char *grade);

/* 功能函数 */
void menu();
void addStudent();
void showStudents();
void searchStudent();
void modifyStudent();
void deleteStudent();
void addGradeForStudent();
void sortByAverageScore();
void statistics();
void undoDelete();

void inputGrades(Student *s);
void showOneStudent(Student s);
float getAverageScore(Student s);

GradeNode *createGradeNode(char subject[], float score);
void freeGrades(GradeNode *head);
GradeNode *copyGrades(GradeNode *head);

unsigned int hashFunc(char id[]);
void insertHash(char id[], StudentNode *ptr);
void removeHash(char id[]);
StudentNode *searchHash(char id[]);

Student copyStudent(Student s);
void freeStudent(Student s);
void pushUndo(Student s);

void quickSort(StudentNode *arr[], int left, int right);
void freeAllStudents();
void freeHashTable();
void freeUndoStack();

int isAllDigits(const char *str);
int isValidName(const char *str);
int isValidDorm(const char *str);

int main()
{
    int choice;

    while (1)
    {
        menu();
        choice = readInt("请输入你的选择：");

        switch (choice)
        {
        case 1:
            addStudent();
            break;
        case 2:
            showStudents();
            break;
        case 3:
            searchStudent();
            break;
        case 4:
            modifyStudent();
            break;
        case 5:
            deleteStudent();
            break;
        case 6:
            addGradeForStudent();
            break;
        case 7:
            sortByAverageScore();
            break;
        case 8:
            statistics();
            break;
        case 9:
            undoDelete();
            break;
        case 0:
            freeAllStudents();
            freeHashTable();
            freeUndoStack();
            printf("程序已退出，相关内存已释放。\n");
            return 0;
        default:
            printf("输入有误，请重新选择！\n");
        }
    }
}

/* 读取一整行 */
void readLine(char *buffer, int size)
{
    fgets(buffer, size, stdin);

    size_t len = strlen(buffer);
    if (len > 0 && buffer[len - 1] == '\n')
    {
        buffer[len - 1] = '\0';
    }
}

/* 读取整数 */
int readInt(const char *prompt)
{
    char line[100];
    int value;
    char extra;

    while (1)
    {
        printf("%s", prompt);
        readLine(line, sizeof(line));

        if (sscanf(line, "%d %c", &value, &extra) == 1)
        {
            return value;
        }

        printf("输入错误！请输入整数，例如：1、20、2024。\n");
    }
}

/* 读取浮点数并限制范围 */
float readFloat(const char *prompt, float min, float max)
{
    char line[100];
    float value;
    char extra;

    while (1)
    {
        printf("%s", prompt);
        readLine(line, sizeof(line));

        if (sscanf(line, "%f %c", &value, &extra) == 1)
        {
            if (value >= min && value <= max)
            {
                return value;
            }
            printf("输入错误！数值范围应为 %.1f 到 %.1f。\n", min, max);
        }
        else
        {
            printf("输入错误！请输入数字，例如：85、92.5。\n");
        }
    }
}

/* 读取普通字符串 */
void readString(const char *prompt, char *buffer, int size)
{
    while (1)
    {
        printf("%s", prompt);
        readLine(buffer, size);

        if (strlen(buffer) > 0)
        {
            return;
        }

        printf("输入不能为空，请重新输入。\n");
    }
}

/* 判断是否全为数字 */
int isAllDigits(const char *str)
{
    if (strlen(str) == 0)
    {
        return 0;
    }

    for (int i = 0; str[i] != '\0'; i++)
    {
        if (!isdigit((unsigned char)str[i]))
        {
            return 0;
        }
    }

    return 1;
}

/* 学号必须为 12 位数字 */
void readStudentId(char *id)
{
    char temp[100];

    while (1)
    {
        printf("请输入学号（12位数字）：");
        readLine(temp, sizeof(temp));

        if (strlen(temp) == 12 && isAllDigits(temp))
        {
            strcpy(id, temp);
            return;
        }

        printf("输入错误！学号必须是 12 位数字，例如：202500120055。\n");
    }
}

/* 手机号必须为 11 位数字 */
void readPhone(char *phone)
{
    char temp[100];

    while (1)
    {
        printf("请输入手机号（11位数字）：");
        readLine(temp, sizeof(temp));

        if (strlen(temp) == 11 && isAllDigits(temp))
        {
            strcpy(phone, temp);
            return;
        }

        printf("输入错误！手机号必须是 11 位数字。\n");
    }
}

/* 姓名检查：不能为空，不能包含数字 */
int isValidName(const char *str)
{
    if (strlen(str) == 0)
    {
        return 0;
    }

    for (int i = 0; str[i] != '\0'; i++)
    {
        if (isdigit((unsigned char)str[i]))
        {
            return 0;
        }
    }

    return 1;
}

void readName(char *name)
{
    char temp[100];

    while (1)
    {
        printf("请输入姓名：");
        readLine(temp, sizeof(temp));

        if (isValidName(temp))
        {
            strncpy(name, temp, NAME_LEN - 1);
            name[NAME_LEN - 1] = '\0';
            return;
        }

        printf("输入错误！姓名不能为空，且不能包含数字。\n");
    }
}

/* 宿舍门牌号检查：不能为空 */
int isValidDorm(const char *str)
{
    return strlen(str) > 0;
}

void readDorm(char *dorm)
{
    char temp[100];

    while (1)
    {
        printf("请输入宿舍门牌号：");
        readLine(temp, sizeof(temp));

        if (isValidDorm(temp))
        {
            strncpy(dorm, temp, DORM_LEN - 1);
            dorm[DORM_LEN - 1] = '\0';
            return;
        }

        printf("输入错误！宿舍门牌号不能为空。\n");
    }
}

/* 性别选择 */
void chooseGender(char *gender)
{
    int choice;

    while (1)
    {
        printf("请选择性别：\n");
        printf("1. 男\n");
        printf("2. 女\n");
        choice = readInt("请输入选项：");

        if (choice == 1)
        {
            strcpy(gender, "男");
            return;
        }
        else if (choice == 2)
        {
            strcpy(gender, "女");
            return;
        }
        else
        {
            printf("输入错误！性别只能选择 1 或 2。\n");
        }
    }
}

/* 年级选择 */
void chooseGrade(char *grade)
{
    int choice;

    while (1)
    {
        printf("请选择年级：\n");
        printf("1. 大一\n");
        printf("2. 大二\n");
        printf("3. 大三\n");
        printf("4. 大四\n");
        choice = readInt("请输入选项：");

        if (choice == 1)
        {
            strcpy(grade, "大一");
            return;
        }
        else if (choice == 2)
        {
            strcpy(grade, "大二");
            return;
        }
        else if (choice == 3)
        {
            strcpy(grade, "大三");
            return;
        }
        else if (choice == 4)
        {
            strcpy(grade, "大四");
            return;
        }
        else
        {
            printf("输入错误！年级只能选择 1 到 4。\n");
        }
    }
}

void menu()
{
    printf("\n=====================================\n");
    printf("        学生信息管理系统\n");
    printf("=====================================\n");
    printf("1. 添加学生信息\n");
    printf("2. 显示所有学生信息\n");
    printf("3. 按学号查找学生\n");
    printf("4. 修改学生基本信息\n");
    printf("5. 删除学生信息\n");
    printf("6. 为已有学生添加课程成绩\n");
    printf("7. 按平均成绩排序显示\n");
    printf("8. 成绩统计\n");
    printf("9. 撤销上一次删除\n");
    printf("0. 退出系统\n");
    printf("=====================================\n");
}

/* 添加学生 */
void addStudent()
{
    StudentNode *newNode = (StudentNode *)malloc(sizeof(StudentNode));

    if (newNode == NULL)
    {
        printf("内存申请失败！\n");
        return;
    }

    newNode->data.grades = NULL;
    newNode->next = NULL;

    readStudentId(newNode->data.id);

    if (searchHash(newNode->data.id) != NULL)
    {
        printf("该学号已存在，添加失败！\n");
        free(newNode);
        return;
    }

    readName(newNode->data.name);

    newNode->data.age = readInt("请输入年龄：");
    while (newNode->data.age <= 0 || newNode->data.age > 100)
    {
        printf("年龄不合理，请输入 1 到 100 之间的整数。\n");
        newNode->data.age = readInt("请重新输入年龄：");
    }

    chooseGender(newNode->data.gender);

    readString("请输入专业：", newNode->data.major, MAJOR_LEN);

    chooseGrade(newNode->data.gradeYear);

    readDorm(newNode->data.dorm);

    readPhone(newNode->data.phone);

    printf("\n开始录入课程成绩。\n");
    inputGrades(&newNode->data);

    newNode->next = studentHead;
    studentHead = newNode;
    studentCount++;

    insertHash(newNode->data.id, newNode);

    printf("学生信息添加成功！\n");
}

/* 输入多门成绩 */
void inputGrades(Student *s)
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
        score = readFloat(prompt, 0, 100);

        GradeNode *newGrade = createGradeNode(subject, score);

        if (newGrade == NULL)
        {
            printf("成绩结点创建失败！\n");
            return;
        }

        newGrade->next = s->grades;
        s->grades = newGrade;

        printf("成绩录入成功！\n");
    }
}

/* 创建成绩结点 */
GradeNode *createGradeNode(char subject[], float score)
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

/* 显示所有学生 */
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

/* 显示单个学生 */
void showOneStudent(Student s)
{
    printf("学号：%s\n", s.id);
    printf("姓名：%s\n", s.name);
    printf("年龄：%d\n", s.age);
    printf("性别：%s\n", s.gender);
    printf("专业：%s\n", s.major);
    printf("年级：%s\n", s.gradeYear);
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

/* 查找学生 */
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

/* 修改学生基本信息 */
void modifyStudent()
{
    char id[ID_LEN];

    readStudentId(id);

    StudentNode *target = searchHash(id);

    if (target == NULL)
    {
        printf("未找到该学生，无法修改！\n");
        return;
    }

    readName(target->data.name);

    target->data.age = readInt("请输入新的年龄：");
    while (target->data.age <= 0 || target->data.age > 100)
    {
        printf("年龄不合理，请输入 1 到 100 之间的整数。\n");
        target->data.age = readInt("请重新输入新的年龄：");
    }

    chooseGender(target->data.gender);
    readString("请输入新的专业：", target->data.major, MAJOR_LEN);
    chooseGrade(target->data.gradeYear);
    readDorm(target->data.dorm);
    readPhone(target->data.phone);

    printf("学生基本信息修改成功！\n");
}

/* 删除学生 */
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

    pushUndo(cur->data);

    if (pre == NULL)
    {
        studentHead = cur->next;
    }
    else
    {
        pre->next = cur->next;
    }

    removeHash(id);
    freeGrades(cur->data.grades);
    free(cur);
    studentCount--;

    printf("学生信息删除成功！可以通过菜单 9 撤销本次删除。\n");
}

/* 给已有学生添加成绩 */
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

/* 按平均成绩排序 */
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

    quickSort(arr, 0, studentCount - 1);

    printf("\n按平均成绩从高到低排序结果：\n");

    for (i = 0; i < studentCount; i++)
    {
        printf("\n第 %d 名：\n", i + 1);
        showOneStudent(arr[i]->data);
    }

    free(arr);
}

/* 快速排序 */
void quickSort(StudentNode *arr[], int left, int right)
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

/* 成绩统计 */
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

/* 撤销删除 */
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
    newNode->next = studentHead;
    studentHead = newNode;
    studentCount++;

    insertHash(newNode->data.id, newNode);

    free(temp);

    printf("撤销删除成功，学生信息已恢复。\n");
}

/* 计算平均成绩 */
float getAverageScore(Student s)
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

/* 字符串学号哈希函数 */
unsigned int hashFunc(char id[])
{
    unsigned int hash = 0;

    for (int i = 0; id[i] != '\0'; i++)
    {
        hash = hash * 31 + id[i];
    }

    return hash % HASH_SIZE;
}

/* 插入哈希表 */
void insertHash(char id[], StudentNode *ptr)
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

/* 从哈希表删除 */
void removeHash(char id[])
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

/* 哈希查找 */
StudentNode *searchHash(char id[])
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

/* 复制成绩链表 */
GradeNode *copyGrades(GradeNode *head)
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

/* 复制学生信息 */
Student copyStudent(Student s)
{
    Student copy = s;
    copy.grades = copyGrades(s.grades);
    return copy;
}

/* 删除前压入撤销栈 */
void pushUndo(Student s)
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

/* 释放成绩链表 */
void freeGrades(GradeNode *head)
{
    GradeNode *temp;

    while (head != NULL)
    {
        temp = head;
        head = head->next;
        free(temp);
    }
}

/* 释放单个学生中的成绩链表 */
void freeStudent(Student s)
{
    freeGrades(s.grades);
}

/* 释放所有学生 */
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

/* 释放哈希表 */
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

/* 释放撤销栈 */
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