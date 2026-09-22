#include <stdio.h>
#include <string.h>
#include "academic.h"
#include "input.h"

/*
 * academic.c 负责年级、学院、专业、班级等学籍信息的选择。
 * 学院和专业使用固定数组保存，菜单序号与数组下标一一对应。
 */

/*
 * 学院列表。
 * static 表示该数组只在 academic.c 文件内部使用；const 表示这些学院名称是固定菜单数据，不能被修改。
 * 数组下标从 0 开始，而菜单编号从 1 开始，所以使用时需要 choice - 1。
 */
static const char *colleges[] =
{
    "信息科学与工程学院",
    "计算机科学与技术学院",
    "网络空间安全学院",
    "生命科学学院",
    "环境科学与工程学院",
    "法学院",
    "政治学与公共管理学院"
};

/* 信息科学与工程学院专业列表。 */
static const char *infoMajors[] =
{
    "通信工程",
    "电子科学与技术",
    "光电信息科学与工程",
    "崇信学堂",
    "微纳光电子新工科实验班",
    "光电科创精英班"
};

/* 计算机科学与技术学院专业列表。 */
static const char *csMajors[] =
{
    "计算机科学与技术",
    "人工智能",
    "数据科学与大数据技术"
};

/* 网络空间安全学院专业列表。 */
static const char *cyberMajors[] =
{
    "网络空间安全",
    "密码科学与技术"
};

/* 生命科学学院专业列表。 */
static const char *lifeMajors[] =
{
    "生物科学",
    "生物技术",
    "生物工程"
};

/* 环境科学与工程学院专业列表。 */
static const char *envMajors[] =
{
    "环境工程",
    "环境科学"
};

/* 法学院专业列表。 */
static const char *lawMajors[] =
{
    "法学"
};

/* 政治学与公共管理学院专业列表。 */
static const char *politicsMajors[] =
{
    "政治学与经济学",
    "国际政治",
    "行政管理"
};


/* 选择年级，并把选择结果写入 grade。 */
static void chooseGrade(char *grade)
{
    int choice;

    printf("请选择年级：\n");
    printf("1. 大一\n");
    printf("2. 大二\n");
    printf("3. 大三\n");
    printf("4. 大四\n");

    choice = readIntRange("请输入选项：", 1, 4);

    if (choice == 1)
    {
        strcpy(grade, "大一");
    }
    else if (choice == 2)
    {
        strcpy(grade, "大二");
    }
    else if (choice == 3)
    {
        strcpy(grade, "大三");
    }
    else
    {
        strcpy(grade, "大四");
    }
}

/*
 * 选择学院。
 * 先遍历 colleges 字符串数组显示菜单，再读取用户选择。
 * 返回值是学院编号，后续 chooseMajorByCollege 会根据这个编号显示对应专业列表。
 */
static int chooseCollege(char *college)
{
    printf("请选择学院：\n");

    for (int i = 0; i < 7; i++)
    {
        printf("%d. %s\n", i + 1, colleges[i]);
    }

    int choice = readIntRange("请输入选项：", 1, 7);

    strcpy(college, colleges[choice - 1]);

    return choice;
}

/*
 * 从指定专业数组中选择一个专业。
 * majors 是“字符串数组”，count 是该数组中专业的个数。
 * 这个函数被多个学院复用，避免每个学院都单独写一套专业选择代码。
 */
static void chooseMajorFromList(char *major, const char *majors[], int count)
{
    printf("请选择专业：\n");

    for (int i = 0; i < count; i++)
    {
        printf("%d. %s\n", i + 1, majors[i]);
    }

    int choice = readIntRange("请输入选项：", 1, count);

    strcpy(major, majors[choice - 1]);
}

/*
 * 根据学院序号分派到对应专业列表。
 * 这一步体现“学院 -> 专业列表”的映射关系：用户选择不同学院，就进入不同专业数组。
 */
static void chooseMajorByCollege(int collegeChoice, char *major)
{
    switch (collegeChoice)
    {
    case 1:
        chooseMajorFromList(major, infoMajors, 6);
        break;
    case 2:
        chooseMajorFromList(major, csMajors, 3);
        break;
    case 3:
        chooseMajorFromList(major, cyberMajors, 2);
        break;
    case 4:
        chooseMajorFromList(major, lifeMajors, 3);
        break;
    case 5:
        chooseMajorFromList(major, envMajors, 2);
        break;
    case 6:
        chooseMajorFromList(major, lawMajors, 1);
        break;
    case 7:
        chooseMajorFromList(major, politicsMajors, 3);
        break;
    default:
        strcpy(major, "未知专业");
    }
}

/*
 * 判断是否为不需要填写普通行政班的特殊培养项目。
 * 如果专业属于这些特殊项目，后续班级字段直接写“无需填写”。
 */
static int noClassNeeded(const char *major)
{
    return strcmp(major, "崇信学堂") == 0 ||
           strcmp(major, "微纳光电子新工科实验班") == 0 ||
           strcmp(major, "光电科创精英班") == 0;
}

/* 根据专业规则录入班级；特殊项目直接写入“无需填写”。 */
static void inputClassName(char *className, const char *major)
{
    if (noClassNeeded(major))
    {
        strcpy(className, "无需填写");
        return;
    }

    int classNumber;

    classNumber = readIntRange("请输入班级编号，例如输入 1 表示 1班：", 1, 99);

    sprintf(className, "%d班", classNumber);
}

/*
 * 新增学生时录入完整学籍信息。
 * 录入顺序是：年级 -> 学院 -> 专业 -> 班级。
 * 如果是大一学生，则按业务规则暂不分专业和班级，直接写入提示文本。
 */
void chooseAcademicInfo(Student *s)
{
    chooseGrade(s->gradeYear);

    int collegeChoice = chooseCollege(s->college);

    if (strcmp(s->gradeYear, "大一") == 0)
    {
        strcpy(s->major, "大一暂未分专业");
        strcpy(s->className, "大一暂未分班");
        return;
    }

    chooseMajorByCollege(collegeChoice, s->major);

    inputClassName(s->className, s->major);
}
/* 修改时选择年级；返回 0 表示用户取消修改。 */
static int chooseGradeCancelable(char *grade)
{
    int choice;

    printf("请选择新的年级：\n");
    printf("1. 大一\n");
    printf("2. 大二\n");
    printf("3. 大三\n");
    printf("4. 大四\n");
    printf("0. 取消修改\n");

    choice = readIntRange("请输入选项：", 0, 4);

    if (choice == 0)
    {
        return 0;
    }
    else if (choice == 1)
    {
        strcpy(grade, "大一");
    }
    else if (choice == 2)
    {
        strcpy(grade, "大二");
    }
    else if (choice == 3)
    {
        strcpy(grade, "大三");
    }
    else
    {
        strcpy(grade, "大四");
    }

    return 1;
}

/* 修改时选择学院；返回 0 表示取消，否则返回学院序号。 */
static int chooseCollegeCancelable(char *college)
{
    printf("请选择新的学院：\n");

    for (int i = 0; i < 7; i++)
    {
        printf("%d. %s\n", i + 1, colleges[i]);
    }

    printf("0. 取消修改\n");

    int choice = readIntRange("请输入选项：", 0, 7);

    if (choice == 0)
    {
        return 0;
    }

    strcpy(college, colleges[choice - 1]);

    return choice;
}

/* 修改时从专业列表中选择专业；支持输入 0 取消。 */
static int chooseMajorFromListCancelable(char *major, const char *majors[], int count)
{
    printf("请选择新的专业：\n");

    for (int i = 0; i < count; i++)
    {
        printf("%d. %s\n", i + 1, majors[i]);
    }

    printf("0. 取消修改\n");

    int choice = readIntRange("请输入选项：", 0, count);

    if (choice == 0)
    {
        return 0;
    }

    strcpy(major, majors[choice - 1]);
    return 1;
}

/* 修改时根据学院序号选择专业；任何一步取消都会向上返回 0。 */
static int chooseMajorByCollegeCancelable(int collegeChoice, char *major)
{
    switch (collegeChoice)
    {
    case 1:
        return chooseMajorFromListCancelable(major, infoMajors, 6);
    case 2:
        return chooseMajorFromListCancelable(major, csMajors, 3);
    case 3:
        return chooseMajorFromListCancelable(major, cyberMajors, 2);
    case 4:
        return chooseMajorFromListCancelable(major, lifeMajors, 3);
    case 5:
        return chooseMajorFromListCancelable(major, envMajors, 2);
    case 6:
        return chooseMajorFromListCancelable(major, lawMajors, 1);
    case 7:
        return chooseMajorFromListCancelable(major, politicsMajors, 3);
    default:
        strcpy(major, "未知专业");
        return 1;
    }
}

/* 修改时录入班级，支持输入 0 取消本次学籍信息修改。 */
static int inputClassNameCancelable(char *className, const char *major)
{
    if (noClassNeeded(major))
    {
        strcpy(className, "无需填写");
        return 1;
    }

    int classNumber = readIntRange("请输入新的班级编号，例如输入 1 表示 1班；输入 0 取消：", 0, 99);

    if (classNumber == 0)
    {
        return 0;
    }

    sprintf(className, "%d班", classNumber);
    return 1;
}

/*
 * 修改学生学籍信息的总入口。
 * 与新增不同，修改过程允许用户输入 0 取消；只要某一步取消，就返回 0，调用者不会保存本次修改。
 */
int chooseAcademicInfoCancelable(Student *s)
{
    if (!chooseGradeCancelable(s->gradeYear))
    {
        return 0;
    }

    int collegeChoice = chooseCollegeCancelable(s->college);

    if (collegeChoice == 0)
    {
        return 0;
    }

    if (strcmp(s->gradeYear, "大一") == 0)
    {
        strcpy(s->major, "大一暂未分专业");
        strcpy(s->className, "大一暂未分班");
        return 1;
    }

    if (!chooseMajorByCollegeCancelable(collegeChoice, s->major))
    {
        return 0;
    }

    if (!inputClassNameCancelable(s->className, s->major))
    {
        return 0;
    }

    return 1;
}