#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#define MAX_STUDENTS 100
#define MAX_NAME_LEN 50

typedef struct {
    char name[MAX_NAME_LEN];
    int score;
    int rank;
} Student;

// 清除输入缓冲区
void clearInputBuffer() {
    int c;
    while ((c = getchar()) != '\n' && c != EOF);
}

// 输入学生信息
void inputStudents(Student students[], int *n) {
    printf("请输入学生人数（1-%d）：", MAX_STUDENTS);
    while (scanf("%d", n) != 1 || *n <= 0 || *n > MAX_STUDENTS) {
        printf("输入无效！请重新输入学生人数（1-%d）：", MAX_STUDENTS);
        clearInputBuffer();
    }
    clearInputBuffer();
    
    printf("请依次输入%d名学生的姓名和分数（格式：姓名 分数）：\n", *n);
    for (int i = 0; i < *n; i++) {
        printf("学生%d: ", i + 1);
        while (scanf("%s %d", students[i].name, &students[i].score) != 2 || students[i].score < 0) {
            printf("输入格式错误！请重新输入（姓名 分数）：");
            clearInputBuffer();
        }
        clearInputBuffer();
    }
}

// 按分数降序排序（使用冒泡排序）
void sortStudents(Student students[], int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - 1 - i; j++) {
            if (students[j].score < students[j + 1].score) {
                Student temp = students[j];
                students[j] = students[j + 1];
                students[j + 1] = temp;
            }
        }
    }
}

// 计算名次（相同分数同名次）
void calculateRanks(Student students[], int n) {
    students[0].rank = 1;
    for (int i = 1; i < n; i++) {
        if (students[i].score == students[i - 1].score) {
            students[i].rank = students[i - 1].rank;
        } else {
            students[i].rank = i + 1;
        }
    }
}

// 打印结果
void printResults(Student students[], int n) {
    printf("\n成绩排名结果：\n");
    printf("名次\t姓名\t\t分数\n");
    printf("------------------------\n");
    
    for (int i = 0; i < n; i++) {
        printf("%d\t%-10s\t%d\n", students[i].rank, students[i].name, students[i].score);
    }
}

int main() {
    Student students[MAX_STUDENTS];
    int n;
    
    inputStudents(students, &n);
    sortStudents(students, n);
    calculateRanks(students, n);
    printResults(students, n);
    
    // 添加暂停，防止程序直接退出
    printf("\n按任意键退出...");
    clearInputBuffer();
    getchar();
    
    return 0;
}
