#include <stdio.h>
#include "input.h"
#include "student.h"

/* 打印主菜单。菜单只负责展示选项，真正的业务处理在 main 的 switch 中分发。 */

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

int main()
{
    int choice;

    /* 主循环：每次显示菜单、读取用户选择，并调用对应功能函数。 */
    while (1)
    {
        menu();
        choice = readInt("请输入你的选择：");

        /* 根据菜单编号分发功能，各功能模块内部负责自己的输入校验和数据处理。 */
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
            /* 退出前统一释放链表、哈希表和撤销栈，避免动态申请的内存泄漏。 */
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