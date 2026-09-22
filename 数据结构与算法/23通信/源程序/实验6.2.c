#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MVNum 100
#define MaxInt 32767 // 极大值，即∞

typedef int ArcType;
typedef char VerTextType[20];

typedef struct ArcNode {
    int adjver; // 该边所指向的顶点位置
    struct ArcNode* nextarc; // 指向下一条边的指针
    ArcType weight;
} ArcNode;

typedef struct VNode {
    VerTextType data;
    ArcNode* firstarc;
} VNode, AdjList[MVNum];

typedef struct {
    AdjList vertices;
    int vexnum; // 图的当前顶点数
    int arcnum; // 图的当前边数
} ALGraph;

// 图的邻接矩阵
typedef struct {
    char vexs[MVNum]; // 顶点表
    int arcs[MVNum][MVNum]; // 邻接矩阵
} Graph;

// 临接表存储方式最短路径（dijkstra）
void ShortestPath_DIJ2(ALGraph G, int v0, ArcType D[], int Path[]) {
    int *ok = (int*)calloc(G.vexnum, sizeof(int));
    int i, j;
    
    for (i = 0; i < G.vexnum; i++) {
        Path[i] = -1;
        D[i] = MaxInt;
    }
    D[v0] = 0;
    
    for (i = 0; i < G.vexnum; i++) {
        int min_node = -1;
        for (j = 0; j < G.vexnum; j++) {
            if (!ok[j] && (min_node == -1 || D[j] < D[min_node])) {
                min_node = j;
            }
        }
        if (min_node == -1) break;
        ok[min_node] = 1;

        ArcNode* cur = G.vertices[min_node].firstarc;
        while (cur != NULL) {
            if (!ok[cur->adjver] && D[cur->adjver] > D[min_node] + cur->weight) {
                D[cur->adjver] = D[min_node] + cur->weight;
                Path[cur->adjver] = min_node;
            }
            cur = cur->nextarc;
        }
    }
    free(ok);
}

// 确定点v在G中的位置
int LocateVex(Graph G, char v, int vex) {
    for (int i = 0; i < vex; ++i) {
        if (G.vexs[i] == v) {
            return i;
        }
    }
    return -1;
}

// 初始化图
void InitGraph(Graph* G, int vex) {
    printf("输入点的名称，如a\n");
    for (int i = 0; i < vex; ++i) {
        printf("请输入第%d个点的名称:", i + 1);
        scanf(" %c", &G->vexs[i]);
    }
    printf("\n");

    for (int i = 0; i < vex; ++i) {
        for (int j = 0; j < vex; ++j) {
            G->arcs[i][j] = (j == i) ? 0 : MaxInt;
        }
    }
}

// 创建无向网G
void CreateUDN(Graph* G, int vex, int arc) {
    printf("输入边依附的顶点(node1 node2 weight)\n");
    for (int k = 0; k < arc; ++k) {
        char v1, v2;
        int weight;
        printf("请输入第%d条边依附的顶点和对应的权值:", k + 1);
        scanf(" %c %c %d", &v1, &v2, &weight);
        
        int i = LocateVex(*G, v1, vex);
        int j = LocateVex(*G, v2, vex);
        
        if (i == -1 || j == -1) {
            printf("输入的顶点不存在!\n");
            k--;
            continue;
        }
        
        G->arcs[i][j] = G->arcs[j][i] = weight;
    }
}

// 显示图
void DisplayGraph(Graph G, int vex) {
    for (int i = 0; i < vex; ++i) {
        for (int j = 0; j < vex; ++j) {
            if (G.arcs[i][j] != MaxInt) {
                printf("%d\t", G.arcs[i][j]);
            } else {
                printf("∞\t");
            }
        }
        printf("\n");
    }
}

// 用Dijkstra算法求无向网G的v0顶点到其余顶点的最短路径
void ShortestPath_DIJ(Graph G, int v0, int vex) {
    int *S = (int*)calloc(vex, sizeof(int));
    int *D = (int*)malloc(vex * sizeof(int));
    int *Path = (int*)malloc(vex * sizeof(int));
    
    if (!S || !D || !Path) {
        printf("内存分配失败!\n");
        free(S);
        free(D);
        free(Path);
        return;
    }

    for (int v = 0; v < vex; ++v) {
        S[v] = 0;
        D[v] = G.arcs[v0][v];
        Path[v] = (D[v] < MaxInt) ? v0 : -1;
    }

    S[v0] = 1;
    D[v0] = 0;

    for (int i = 1; i < vex; ++i) {
        int min = MaxInt;
        int v = -1;
        
        for (int w = 0; w < vex; ++w) {
            if (!S[w] && D[w] < min) {
                min = D[w];
                v = w;
            }
        }
        
        if (v == -1) break;
        S[v] = 1;

        for (int w = 0; w < vex; ++w) {
            if (!S[w] && (D[v] + G.arcs[v][w] < D[w])) {
                D[w] = D[v] + G.arcs[v][w];
                Path[w] = v;
            }
        }
    }

    for (int i = 0; i < vex; i++) {
        if (i != v0) {
            if (D[i] != MaxInt) {
                printf("到%c最短路径长度:%d\n", G.vexs[i], D[i]);
            } else {
                printf("到%c最短路径长度:无法到达\n", G.vexs[i]);
            }
        }
    }

    free(S);
    free(D);
    free(Path);
}

int main() {
    Graph G;
    int vexnum, arcnum;
    
    printf("请分别输入总顶点数和总边数:");
    scanf("%d %d", &vexnum, &arcnum);
    
    if (vexnum <= 0 || vexnum > MVNum || arcnum < 0 || arcnum > vexnum * (vexnum - 1) / 2) {
        printf("输入的顶点数或边数不合法!\n");
        return 1;
    }
    
    InitGraph(&G, vexnum);
    CreateUDN(&G, vexnum, arcnum);
    printf("\n已创建无向图G\n\n");
    DisplayGraph(G, vexnum);
    
    char start;
    printf("\n请输入起点顶点:");
    scanf(" %c", &start);
    
    int v0 = LocateVex(G, start, vexnum);
    if (v0 == -1) {
        printf("起点顶点不存在!\n");
        return 1;
    }
    
    ShortestPath_DIJ(G, v0, vexnum);
    return 0;
}
