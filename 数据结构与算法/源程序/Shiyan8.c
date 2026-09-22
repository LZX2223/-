#include <stdio.h>
#include <stdlib.h>

#define MAX_STU 100
#define NAME_LEN 30

typedef struct {
    char name[NAME_LEN];    // 学生姓名
    int score;              // 学生成绩
    int rank;               // 学生名次
} ScoreInfo;

/* 输入学生成绩信息 */
void InputScore(ScoreInfo stu[], int *num) {
    int i;

    printf("请输入学生人数：");
    scanf("%d", num);

    while (*num <= 0 || *num > MAX_STU) {
        printf("人数输入不合法，请重新输入 1-%d 之间的整数：", MAX_STU);
        scanf("%d", num);
    }

    printf("\n请依次输入学生姓名和成绩：\n");
    for (i = 0; i < *num; i++) {
        printf("第 %d 个学生：", i + 1);
        scanf("%s %d", stu[i].name, &stu[i].score);

        while (stu[i].score < 0 || stu[i].score > 100) {
            printf("成绩应在 0-100 之间，请重新输入该学生成绩：");
            scanf("%d", &stu[i].score);
        }

        stu[i].rank = 0;
    }
}

/* 按成绩从高到低进行选择排序 */
void SelectSort(ScoreInfo stu[], int n) {
    int i, j, maxIndex;
    ScoreInfo temp;

    for (i = 0; i < n - 1; i++) {
        maxIndex = i;

        for (j = i + 1; j < n; j++) {
            if (stu[j].score > stu[maxIndex].score) {
                maxIndex = j;
            }
        }

        if (maxIndex != i) {
            temp = stu[i];
            stu[i] = stu[maxIndex];
            stu[maxIndex] = temp;
        }
    }
}

/* 计算名次：分数相同者名次相同 */
void SetRank(ScoreInfo stu[], int n) {
    int i;

    if (n <= 0) {
        return;
    }

    stu[0].rank = 1;

    for (i = 1; i < n; i++) {
        if (stu[i].score == stu[i - 1].score) {
            stu[i].rank = stu[i - 1].rank;
        } else {
            stu[i].rank = i + 1;
        }
    }
}

/* 输出排名结果 */
void PrintScoreList(ScoreInfo stu[], int n) {
    int i;

    printf("\n学生成绩排名表\n");
    printf("--------------------------------\n");
    printf("名次\t姓名\t\t成绩\n");
    printf("--------------------------------\n");

    for (i = 0; i < n; i++) {
        printf("%d\t%-10s\t%d\n", stu[i].rank, stu[i].name, stu[i].score);
    }

    printf("--------------------------------\n");
}

int main() {
    ScoreInfo student[MAX_STU];
    int n;

    InputScore(student, &n);

    SelectSort(student, n);

    SetRank(student, n);

    PrintScoreList(student, n);

    return 0;
}