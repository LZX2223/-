#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "input.h"

/*
 * input.c 集中封装所有键盘输入和合法性检查。
 * 这样 student.c、academic.c 等业务模块只需要调用读取函数，
 * 不必重复处理空输入、非法数字、越界值和输入过长等问题。
 * 这属于“输入处理”和“业务逻辑”分离，能让核心功能代码更清晰。
 */

/*
 * 读取一整行输入。
 * fgets 会把换行符一起读进来，所以这里会手动去掉末尾的 \n。
 * 如果用户输入超过数组容量，就清空本行剩余字符，避免影响下一次输入。
 */
void readLine(char *buffer, int size)
{
    if (fgets(buffer, size, stdin) == NULL)
    {
        buffer[0] = '\0';
        return;
    }

    size_t len = strlen(buffer);
    if (len > 0 && buffer[len - 1] == '\n')
    {
        buffer[len - 1] = '\0';
    }
    else
    {
        int ch;

        while ((ch = getchar()) != '\n' && ch != EOF)
        {
        }
    }
}

/*
 * 读取一个整数。
 * 这里不用 scanf 直接读，而是先读一整行，再用 sscanf 检查格式。
 * %d %c 可以发现 12abc 这类输入，避免它被错误地当成合法整数 12。
 */
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

        printf("输入错误！请输入整数。\n");
    }
}

/* 在指定闭区间 [min, max] 内读取整数，直到输入合法才返回。 */
int readIntRange(const char *prompt, int min, int max)
{
    int value;

    while (1)
    {
        value = readInt(prompt);

        if (value >= min && value <= max)
        {
            return value;
        }

        printf("输入错误！请输入 %d 到 %d 之间的整数。\n", min, max);
    }
}


/* 读取可取消的整数：输入 0 表示取消，其他值必须落在 [min, max] 内。 */
int readIntRangeCancelable(const char *prompt, int min, int max)
{
    int value;

    while (1)
    {
        value = readInt(prompt);

        if (value == 0)
        {
            return 0;
        }

        if (value >= min && value <= max)
        {
            return value;
        }

        printf("输入错误！请输入 %d 到 %d 之间的整数，或输入 0 取消。\n", min, max);
    }
}
/*
 * 在指定闭区间 [min, max] 内读取浮点数，用于录入课程成绩。
 * 成绩允许输入 85 或 92.5 这样的数字，但必须限制在 0 到 100 之间。
 */
float readFloatRange(const char *prompt, float min, float max)
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

/* 读取非空字符串，常用于宿舍、课程名等没有复杂格式限制的字段。 */
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

/* 判断字符串是否全部由数字组成，空字符串直接判为非法。 */
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

/*
 * 读取并校验学号。
 * 本系统把学号作为唯一标识，也是哈希表查找的关键字，所以必须保证格式统一。
 * 这里要求学号固定为 12 位数字。
 */
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

/* 判断姓名是否合法：不能为空，且不能包含数字字符。 */
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

/*
 * 读取姓名，并用 strncpy 控制拷贝长度。
 * 姓名先读入临时数组 temp，校验通过后再复制到 Student 结构体中，避免超过结构体字段容量。
 */
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


/* 修改信息时读取姓名；输入 0 表示放弃本次修改。 */
int readNameCancelable(char *name)
{
    char temp[100];

    while (1)
    {
        printf("请输入新的姓名（输入 0 取消）：");
        readLine(temp, sizeof(temp));

        if (strcmp(temp, "0") == 0)
        {
            return 0;
        }

        if (isValidName(temp))
        {
            strncpy(name, temp, NAME_LEN - 1);
            name[NAME_LEN - 1] = '\0';
            return 1;
        }

        printf("输入错误！姓名不能为空，且不能包含数字。\n");
    }
}
/* 读取手机号：固定要求 11 位数字。 */
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


/* 修改信息时读取手机号；输入 0 表示放弃本次修改。 */
int readPhoneCancelable(char *phone)
{
    char temp[100];

    while (1)
    {
        printf("请输入新的手机号（11位数字，输入 0 取消）：");
        readLine(temp, sizeof(temp));

        if (strcmp(temp, "0") == 0)
        {
            return 0;
        }

        if (strlen(temp) == 11 && isAllDigits(temp))
        {
            strcpy(phone, temp);
            return 1;
        }

        printf("输入错误！手机号必须是 11 位数字。\n");
    }
}
/* 读取宿舍门牌号，只要求非空。 */
void readDorm(char *dorm)
{
    readString("请输入宿舍门牌号：", dorm, DORM_LEN);
}


/* 修改信息时读取宿舍门牌号；输入 0 表示放弃本次修改。 */
int readDormCancelable(char *dorm)
{
    char temp[100];

    while (1)
    {
        printf("请输入新的宿舍门牌号（输入 0 取消）：");
        readLine(temp, sizeof(temp));

        if (strcmp(temp, "0") == 0)
        {
            return 0;
        }

        if (strlen(temp) > 0)
        {
            strncpy(dorm, temp, DORM_LEN - 1);
            dorm[DORM_LEN - 1] = '\0';
            return 1;
        }

        printf("输入不能为空，请重新输入。\n");
    }
}
/* 通过菜单选择性别，并把中文结果写入 gender 字符数组。 */
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

        printf("输入错误！性别只能选择 1 或 2。\n");
    }
}
/* 修改信息时选择性别；输入 0 表示放弃本次修改。 */
int chooseGenderCancelable(char *gender)
{
    int choice;

    while (1)
    {
        printf("请选择新的性别：\n");
        printf("1. 男\n");
        printf("2. 女\n");
        printf("0. 取消修改\n");

        choice = readIntRange("请输入选项：", 0, 2);

        if (choice == 0)
        {
            return 0;
        }
        else if (choice == 1)
        {
            strcpy(gender, "男");
            return 1;
        }
        else if (choice == 2)
        {
            strcpy(gender, "女");
            return 1;
        }
    }
}