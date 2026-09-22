#ifndef ACADEMIC_H
#define ACADEMIC_H

/* academic 模块负责录入和修改学生的年级、学院、专业、班级信息。 */

#include "common.h"

/* 新增学生时录入学籍信息。 */
void chooseAcademicInfo(Student *s);
/* 修改学生时录入学籍信息，返回 0 表示用户取消。 */
int chooseAcademicInfoCancelable(Student *s);

#endif