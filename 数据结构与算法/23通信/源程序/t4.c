#include <stdio.h>
#include <stdlib.h>

// 定义二叉排序树的节点结构
typedef struct TreeNode {
    int value;
    struct TreeNode *left;
    struct TreeNode *right;
} TreeNode;

// 定义队列节点结构（用于层次遍历打印树）
typedef struct QueueNode {
    TreeNode *treeNode;
    struct QueueNode *next;
} QueueNode;

// 定义队列结构
typedef struct Queue {
    QueueNode *front;
    QueueNode *rear;
} Queue;

// 创建新的节点
TreeNode* createNode(int value) {
    TreeNode *node = (TreeNode *)malloc(sizeof(TreeNode));
    node->value = value;
    node->left = NULL;
    node->right = NULL;
    return node;
}

// 插入节点到二叉排序树
TreeNode* insert(TreeNode *root, int value) {
    if (root == NULL) {
        return createNode(value);
    }
    if (value < root->value) {
        root->left = insert(root->left, value);
    } else if (value > root->value) {
        root->right = insert(root->right, value);
    }
    return root;
}

// 中序遍历（递增顺序输出）
void inorderTraversal(TreeNode *root) {
    if (root != NULL) {
        inorderTraversal(root->left);
        printf("%d ", root->value);
        inorderTraversal(root->right);
    }
}

// 查找节点
int search(TreeNode *root, int key) {
    if (root == NULL) {
        return 0;  // 未找到
    }
    if (key == root->value) {
        return 1;  // 找到
    } else if (key < root->value) {
        return search(root->left, key);
    } else {
        return search(root->right, key);
    }
}

// 插入节点的函数（如果不存在则插入）
TreeNode* insertIfNotFound(TreeNode *root, int key) {
    if (!search(root, key)) {
        root = insert(root, key);
    }
    return root;
}

// 反向中序遍历（递减顺序输出）
void reverseInorderTraversal(TreeNode *root) {
    if (root != NULL) {
        reverseInorderTraversal(root->right);
        printf("%d ", root->value);
        reverseInorderTraversal(root->left);
    }
}

// 初始化队列
Queue* createQueue() {
    Queue *q = (Queue *)malloc(sizeof(Queue));
    q->front = q->rear = NULL;
    return q;
}

// 入队
void enqueue(Queue *q, TreeNode *treeNode) {
    QueueNode *newNode = (QueueNode *)malloc(sizeof(QueueNode));
    newNode->treeNode = treeNode;
    newNode->next = NULL;
    if (q->rear == NULL) {
        q->front = q->rear = newNode;
        return;
    }
    q->rear->next = newNode;
    q->rear = newNode;
}

// 出队
TreeNode* dequeue(Queue *q) {
    if (q->front == NULL) {
        return NULL;
    }
    QueueNode *temp = q->front;
    TreeNode *treeNode = temp->treeNode;
    q->front = q->front->next;
    if (q->front == NULL) {
        q->rear = NULL;
    }
    free(temp);
    return treeNode;
}

// 判断队列是否为空
int isQueueEmpty(Queue *q) {
    return q->front == NULL;
}

// 打印二叉树的结构（按层次遍历）
void printTreeStructure(TreeNode *root) {
    if (root == NULL) {
        printf("树为空。\n");
        return;
    }

    Queue *q = createQueue();
    enqueue(q, root);

    printf("二叉树的结构（按层次输出）：\n");
    while (!isQueueEmpty(q)) {
        int levelSize = 0;
        Queue *tempQueue = createQueue();
        
        // 先计算当前层的节点数并保存节点到临时队列
        while (!isQueueEmpty(q)) {
            TreeNode *node = dequeue(q);
            enqueue(tempQueue, node);
            levelSize++;
        }
        
        // 打印当前层节点并处理子节点
        for (int i = 0; i < levelSize; i++) {
            TreeNode *node = dequeue(tempQueue);
            printf("%d ", node->value);

            if (node->left != NULL) {
                enqueue(q, node->left);
            }
            if (node->right != NULL) {
                enqueue(q, node->right);
            }
        }
        printf("\n");  // 换行表示下一层
        free(tempQueue);
    }

    free(q);
}
// 释放二叉树内存
void freeTree(TreeNode *root) {
    if (root != NULL) {
        freeTree(root->left);
        freeTree(root->right);
        free(root);
    }
}

int main() {
    int T;
    printf("请输入测试数据组数 T: ");
    scanf("%d", &T);

    while (T--) {
        int n;
        printf("\n请输入二叉排序树的节点个数 n: ");
        scanf("%d", &n);

        TreeNode *root = NULL;
        printf("请输入 %d 个整数: ", n);
        for (int i = 0; i < n; i++) {
            int value;
            scanf("%d", &value);
            root = insert(root, value);
        }

        // 打印二叉树结构
        printTreeStructure(root);

        // 按递增顺序输出
        printf("递增顺序输出二叉排序树: ");
        inorderTraversal(root);
        printf("\n");

        // 查找 key
        int key;
        printf("请输入要查找的整数 key: ");
        scanf("%d", &key);
        if (search(root, key)) {
            printf("find\n");
        } else {
            printf("not find\n");
        }

        // 插入 key（如果不存在）
        printf("请输入要插入的整数 key: ");
        scanf("%d", &key);
        root = insertIfNotFound(root, key);

        // 按递减顺序输出
        printf("递减顺序输出二叉排序树: ");
        reverseInorderTraversal(root);
        printf("\n");

        // 释放内存
        freeTree(root);
    }

    return 0;
}
