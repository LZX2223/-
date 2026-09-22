#include <stdio.h>
#include <stdlib.h>

#define LEFT 1
#define RIGHT 2

typedef struct BSTreeNode {
    int data;
    struct BSTreeNode* left;  //左子树
    struct BSTreeNode* right; //右子树
} BSTree;

BSTree* Create_BSTreeNode(BSTree* nod);                  //创建二叉查找树
void PreOrder_Traverse(BSTree* nod, int level);          //前序遍历二叉树，并打印
void SearchData(int targ, BSTree* nod);                  //查找特定值
BSTree* AddNewNode(BSTree* cur, int NewData);            //添加新的节点
void DeletNode(BSTree* parent, BSTree* cur, int DelData);//删除节点
BSTree* SearchSuccessorNode(BSTree* nod);                //搜索后继节点
BSTree* SearchParentofSNode(BSTree* Pnod, BSTree* nod);  //搜索后继节点的父节点

int main() {
    BSTree* nod = NULL;
    int num;
    int key;
    int del;

    printf("请输入要创建二叉查找树的数字序列(以0结束):\n");
    nod = Create_BSTreeNode(nod);
    
    printf("前序遍历结果:\n");
    PreOrder_Traverse(nod, 1);

    printf("输入要查找的数据:\n");
    scanf("%d", &num);
    LevelSearch(num, nod);  // 使用新的层级查找方法
    
    printf("输入要插入的新数据:\n");
    scanf("%d", &key);
    nod = AddNewNode(nod, key);

    printf("插入后的前序遍历结果:\n");
    PreOrder_Traverse(nod, 1);

    return 0;
}

//搜索后继节点的父节点
BSTree* SearchParentofSNode(BSTree* Pnod, BSTree* nod) {
    while (1) {
        if (nod->left != NULL) {
            Pnod = nod;
            nod = nod->left;
        } else {
            break;
        }
    }
    return Pnod;
}

//搜索后继节点
BSTree* SearchSuccessorNode(BSTree* nod) {
    while (1) {
        if (nod->left != NULL) {
            nod = nod->left;
        } else {
            break;
        }
    }
    return nod;
}

//添加新节点
BSTree* AddNewNode(BSTree* cur, int NewData) {
    if (cur == NULL) {
        if ((cur = (BSTree*)malloc(sizeof(BSTree))) == NULL) //创建新节点
        {
            printf("内存不足");
            exit(0);
        }
        cur->data = NewData;
        cur->left = NULL;
        cur->right = NULL;
        return cur;
    }
    if (NewData > cur->data) {
        cur->right = AddNewNode(cur->right, NewData);
    } else if (NewData < cur->data) {
        cur->left = AddNewNode(cur->left, NewData);
    } else if (NewData == cur->data) {
    fprintf(stderr, "错误：值 %d 已存在（按任意键退出）\n", NewData);
    getchar();  // 等待用户看清提示
    exit(1);    // 非0表示异常退出
    }
    return cur;
}

//查找特定值
// 按层级查找的新函数
void LevelSearch(int targ, BSTree* root) {
    if (root == NULL) {
        printf("树为空\n");
        return;
    }

    BSTree* queue[100];  // 用队列实现层级遍历
    int front = 0, rear = 0;
    int current_level = 1;
    int nodes_in_current_level = 1;
    int nodes_in_next_level = 0;

    queue[rear++] = root;

    while (front < rear) {
        BSTree* current = queue[front++];
        nodes_in_current_level--;

        printf("比较level %d的节点: %d\n", current_level, current->data);

        // 找到目标值
        if (current->data == targ) {
            printf("find，值为%d，位于level %d\n", targ, current_level);
            return;
        }
        // 当前层级第一个节点 > 目标值，返回上一层
        else if (front == 1 && current->data > targ) {
            if (current_level == 1) {
                printf("根节点已大于目标值，未找到\n");
            } else {
                printf("level %d的第一个节点%d > 目标值%d，返回上一层\n", 
                      current_level, current->data, targ);
            }
            return;
        }
        // 当前节点 < 目标值，继续在该层级查找
        else if (current->data < targ) {
            printf("节点%d < 目标值%d，继续在该层级查找\n", current->data, targ);
        }

        // 将子节点加入队列
        if (current->left != NULL) {
            queue[rear++] = current->left;
            nodes_in_next_level++;
        }
        if (current->right != NULL) {
            queue[rear++] = current->right;
            nodes_in_next_level++;
        }

        // 处理层级切换
        if (nodes_in_current_level == 0) {
            printf("level %d查找完毕，未找到目标值\n", current_level);
            current_level++;
            nodes_in_current_level = nodes_in_next_level;
            nodes_in_next_level = 0;
        }
    }

    printf("未找到目标值%d\n", targ);
}


//创建二叉查找树（数据以前序遍历顺序输入）
BSTree* Create_BSTreeNode(BSTree* nod) {
    int num;
    scanf("%d", &num);
    if (num == 0) //假定输入的数据都为正数，以0作为NULL的标志
    {
        return NULL;
    } else {
        if ((nod = (BSTree*)malloc(sizeof(BSTree))) == NULL) {
            printf("内存空间不足");
            exit(0);
        }
        nod->data = num;
        printf("输入%d的左子节点(0表示空): ", num);
        nod->left = Create_BSTreeNode(nod->left);
        printf("输入%d的右子节点(0表示空): ", num);
        nod->right = Create_BSTreeNode(nod->right);
        return nod;
    }
}

//前序遍历二叉树，并打印
void PreOrder_Traverse(BSTree* nod, int level) {
    if (nod == NULL) {
        return;
    }
    printf("data = %d level = %d\n", nod->data, level);
    PreOrder_Traverse(nod->left, level + 1);
    PreOrder_Traverse(nod->right, level + 1);
}
