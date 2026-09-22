#ifndef COMMON_H
#define COMMON_H

/*
 * 下面这些宏统一规定各个字符串字段的数组长度。
 * 例如学号要求 12 位数字，但 C 语言字符串最后还需要一个 '\0' 结束符，
 * 所以 ID_LEN 定义为 13。集中定义长度，后期修改字段容量时更方便。
 */
#define ID_LEN 13       /* 学号长度：12 位数字 + 字符串结束符 '\0' */
#define NAME_LEN 30     /* 姓名最大保存长度 */
#define GENDER_LEN 10   /* 性别字符串保存长度，例如“男”“女” */
#define GRADE_LEN 20    /* 年级字符串保存长度，例如“大一” */
#define COLLEGE_LEN 80  /* 学院名称最大保存长度 */
#define MAJOR_LEN 80    /* 专业名称最大保存长度 */
#define CLASS_LEN 30    /* 班级名称最大保存长度 */
#define DORM_LEN 30     /* 宿舍门牌号最大保存长度 */
#define PHONE_LEN 12    /* 手机号长度：11 位数字 + 字符串结束符 '\0' */
#define SUBJECT_LEN 30  /* 课程名称最大保存长度 */
#define HASH_SIZE 101   /* 哈希表容量；101 是质数，能在一定程度上减少冲突 */

/*
 * 前置声明结构体类型。
 * 这些结构体之间存在相互引用，例如 Student 中有 GradeNode *，
 * HashNode 中有 StudentNode *。先声明类型名，后面就可以直接写
 * GradeNode、StudentNode，而不必每次都写 struct GradeNode。
 */
typedef struct GradeNode GradeNode;
typedef struct Student Student;
typedef struct StudentNode StudentNode;
typedef struct HashNode HashNode;
typedef struct UndoNode UndoNode;

/*
 * 课程成绩链表结点。
 * 一个 GradeNode 只保存一门课程的名称和成绩，多门课程通过 next 连接成链表。
 * 这样每个学生可以拥有不同数量的课程成绩，不需要提前固定课程个数。
 */
struct GradeNode
{
    char subject[SUBJECT_LEN];  /* 课程名称 */
    float score;                /* 课程成绩 */
    GradeNode *next;            /* 指向下一门课程成绩；NULL 表示已经是最后一门 */
};

/*
 * 学生信息结构体。
 * 这里保存一名学生的完整基本信息和学籍信息。
 * grades 是指向成绩链表的头指针，表示“这个学生自己的成绩表入口”。
 */
struct Student
{
    char id[ID_LEN];               /* 学号，12 位数字字符串，末尾预留 '\0' */
    char name[NAME_LEN];           /* 姓名 */
    int age;                       /* 年龄 */
    char gender[GENDER_LEN];       /* 性别 */
    char gradeYear[GRADE_LEN];     /* 年级 */
    char college[COLLEGE_LEN];     /* 学院 */
    char major[MAJOR_LEN];         /* 专业 */
    char className[CLASS_LEN];     /* 班级 */
    char dorm[DORM_LEN];           /* 宿舍门牌号 */
    char phone[PHONE_LEN];         /* 手机号，11 位数字字符串，末尾预留 '\0' */
    GradeNode *grades;             /* 课程成绩链表头指针，指向该学生第一门课程 */
};

/*
 * 学生链表结点。
 * data 是当前结点保存的完整学生信息，next 指向下一个学生结点。
 * 系统中的所有学生通过 StudentNode 单链表组织起来，形成一个学生信息表。
 */
struct StudentNode
{
    Student data;          /* 当前结点保存的学生信息 */
    StudentNode *next;     /* 指向下一个学生结点；NULL 表示链表结束 */
};

/*
 * 哈希表结点。
 * 哈希表不重复保存完整学生信息，只保存“学号 -> 学生链表结点地址”的映射。
 * 查找学号时，先在哈希表中找到 HashNode，再通过 studentPtr 直接定位真实学生结点。
 */
struct HashNode
{
    char id[ID_LEN];             /* 学号作为哈希查找的键 */
    StudentNode *studentPtr;     /* 指向学生链表中的实际学生结点 */
    HashNode *next;              /* 哈希冲突时连接下一个 HashNode，属于链地址法 */
};

/*
 * 撤销栈结点。
 * 删除学生前，把学生信息复制一份压入这个栈。
 * 栈具有“后进先出”特点，所以撤销时恢复的是最近一次删除的学生。
 */
struct UndoNode
{
    Student data;        /* 被删除学生的信息副本 */
    UndoNode *next;      /* 指向栈中的下一个撤销记录 */
};

#endif