#ifndef INPUT_H
#define INPUT_H

/* input 模块负责所有控制台输入、格式校验和可取消输入。 */

#include "common.h"

/* 读取一行字符串并处理换行和超长输入。 */
void readLine(char *buffer, int size);
/* 读取一个合法整数。 */
int readInt(const char *prompt);
/* 读取指定范围内的整数。 */
int readIntRange(const char *prompt, int min, int max);
/* 读取可取消的范围整数，返回 0 表示取消。 */
int readIntRangeCancelable(const char *prompt, int min, int max);
/* 读取指定范围内的浮点数。 */
float readFloatRange(const char *prompt, float min, float max);

/* 读取非空字符串。 */
void readString(const char *prompt, char *buffer, int size);
/* 读取并校验 12 位学号。 */
void readStudentId(char *id);
/* 读取并校验姓名。 */
void readName(char *name);
/* 修改时读取姓名，返回 0 表示取消。 */
int readNameCancelable(char *name);
/* 读取并校验 11 位手机号。 */
void readPhone(char *phone);
/* 修改时读取手机号，返回 0 表示取消。 */
int readPhoneCancelable(char *phone);
/* 读取宿舍门牌号。 */
void readDorm(char *dorm);
/* 修改时读取宿舍门牌号，返回 0 表示取消。 */
int readDormCancelable(char *dorm);
/* 选择性别。 */
void chooseGender(char *gender);
/* 修改时选择性别，返回 0 表示取消。 */
int chooseGenderCancelable(char *gender);

/* 判断字符串是否全部为数字。 */
int isAllDigits(const char *str);
/* 判断姓名是否非空且不含数字。 */
int isValidName(const char *str);

#endif