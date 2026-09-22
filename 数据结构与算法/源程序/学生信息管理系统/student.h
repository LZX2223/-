#ifndef STUDENT_H
#define STUDENT_H

/* student 模块对外提供学生信息管理的业务功能接口。 */

/* 新增一名学生，并同步维护学生链表和学号哈希表。 */
void addStudent();
/* 遍历学生链表，显示当前保存的所有学生信息。 */
void showStudents();
/* 按学号查找学生，内部通过哈希表加速定位。 */
void searchStudent();
/* 修改学生基本信息，采用“先暂存、后确认保存”的方式。 */
void modifyStudent();
/* 删除学生信息，并把删除前的数据压入撤销栈。 */
void deleteStudent();
/* 为已有学生继续追加课程成绩。 */
void addGradeForStudent();
/* 按平均成绩从高到低显示排序结果。 */
void sortByAverageScore();
/* 统计学生人数、整体平均分、最高平均分和最低平均分。 */
void statistics();
/* 恢复最近一次删除的学生记录。 */
void undoDelete();

/* 程序退出时释放学生链表及每个学生的成绩链表。 */
void freeAllStudents();
/* 程序退出时释放哈希表中的辅助结点。 */
void freeHashTable();
/* 程序退出时释放撤销栈中保存的学生副本。 */
void freeUndoStack();

#endif