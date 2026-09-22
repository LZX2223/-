#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* 商品结构体定义 */
typedef struct Product {
    int id;             // 商品编号
    char name[50];      // 商品名称
    float price;        // 销售价
    float cost;         // 成本价
    int stock;          // 库存量
    struct Product* next;  // 链表指针
} Product;

Product* head = NULL;   // 全局变量，链表头指针

/* 函数声明 */
void show_menu();
int is_id_exist(int id);
void add_product();
void update_stock(int mode);
void display_products();
void search_product_by_id();  
void calculate_total_cost();
void save_to_file();
void load_from_file();
void free_all();

/* 显示主菜单 */
void show_menu() {
    system("cls");  // 清屏
    printf("=== 商品管理系统 ===\n");
    printf("1. 添加商品\n"); 
    printf("2. 商品进货\n");
    printf("3. 商品销售\n");
    printf("4. 显示所有商品\n");
    printf("5. 查询商品信息\n"); 
    printf("6. 计算总成本\n");
    printf("7. 保存数据\n");
    printf("8. 加载数据\n");    
    printf("0. 退出系统\n");
}

/* 检查ID是否已存在 */
int is_id_exist(int id) {
    Product* p = head;
    while (p) {
        if (p->id == id) return 1;
        p = p->next;
    }
    return 0;
}

/* 添加新商品 */
void add_product() {
    Product* new_prod = (Product*)malloc(sizeof(Product));
    
    // 输入商品编号并检查唯一性
    printf("\n输入商品编号：");
    scanf("%d", &new_prod->id);
    if (is_id_exist(new_prod->id)) {
        printf("编号已存在！\n");
        free(new_prod);
        return;
    }

    printf("输入商品名称：");
    scanf("%s", new_prod->name);
    
    // 输入验证：价格和库存必须为正数
    do {
        printf("输入销售价：");
        scanf("%f", &new_prod->price);
    } while (new_prod->price <= 0);

    do {
        printf("输入成本价：");
        scanf("%f", &new_prod->cost);
    } while (new_prod->cost <= 0);

    do {
        printf("输入库存：");
        scanf("%d", &new_prod->stock);
    } while (new_prod->stock < 0);

    // 添加到链表头部
    new_prod->next = head;
    head = new_prod;
    printf("添加成功！\n");
}

/* 更新库存 
   mode: 2-进货, 3-销售 */
void update_stock(int mode) {
    int target_id, quantity;
    printf("\n输入商品编号：");
    scanf("%d", &target_id);
    
    // 查找商品
    Product* p = head;
    while (p && p->id != target_id) p = p->next;
    
    if (!p) {
        printf("商品不存在！\n");
        return;
    }
    
    // 处理库存更新
    printf("当前库存：%d\n输入数量：", p->stock);
    scanf("%d", &quantity);
    
    if (mode == 3) {  // 销售模式
        if (p->stock < quantity) {
            printf("库存不足！\n");
            return;
        }
        p->stock -= quantity;
    } else {          // 进货模式
        p->stock += quantity;
    }
    printf("操作成功！当前库存：%d\n", p->stock);
}

/* 根据编号查询商品详细信息 */
void search_product_by_id() {
    int target_id;
    printf("\n输入要查询的商品编号：");
    scanf("%d", &target_id);
    
    Product* p = head;
    while (p && p->id != target_id) p = p->next;
    
    if (!p) {
        printf("未找到该商品！\n");
        return;
    }
    
    // 格式化输出商品信息
    printf("\n===== 商品详细信息 =====\n");
    printf("商品编号: %d\n", p->id);
    printf("商品名称: %s\n", p->name);
    printf("销售价格: %.2f\n", p->price);
    printf("成本价格: %.2f\n", p->cost);
    printf("库存数量: %d\n", p->stock);
    printf("========================\n");
}

/* 显示所有商品 */
void display_products() {
    printf("\n%-8s%-20s%-10s%-10s%-8s\n", "编号", "名称", "销售价", "成本价", "库存");
    printf("---------------------------------------------------\n");
    
    Product* p = head;
    while (p) {
        printf("%-8d%-20s%-10.2f%-10.2f%-8d\n", 
              p->id, p->name, p->price, p->cost, p->stock);
        p = p->next;
    }
    printf("\n");
}

/* 计算所有商品总成本 */
void calculate_total_cost() {
    float total_cost = 0;
    Product* p = head;
    
    while (p) {
        total_cost += p->cost * p->stock;
        p = p->next;
    }
    
    printf("\n所有商品总成本: %.2f\n", total_cost);
}

/* 保存数据到文件 */
void save_to_file() {
    FILE* fp = fopen("data.txt", "w");
    if (!fp) {
        printf("保存失败！\n");
        return;
    }
    
    Product* p = head;
    while (p) {
        fprintf(fp, "%d %s %.2f %.2f %d\n", 
               p->id, p->name, p->price, p->cost, p->stock);
        p = p->next;
    }
    fclose(fp);
    printf("数据已保存至data.txt！\n");
}

/* 从文件加载数据 */
void load_from_file() {
    FILE* fp = fopen("data.txt", "r");
    if (!fp) {
        printf("未找到数据文件！\n");
        return;
    }
    
    free_all();  // 清空当前链表
    
    Product temp, *new_node;
    while(fscanf(fp, "%d %s %f %f %d", 
                &temp.id, temp.name, &temp.price, &temp.cost, &temp.stock) != EOF) {
        new_node = (Product*)malloc(sizeof(Product));
        *new_node = temp;  // 结构体直接赋值
        new_node->next = head;
        head = new_node;
    }
    fclose(fp);
    printf("数据加载成功！\n");
}

/* 释放所有内存 */
void free_all() {
    Product* p = head;
    while (p) {
        Product* temp = p;
        p = p->next;
        free(temp);
    }
    head = NULL;
}

/* 主函数 */
int main() {
    int choice;
    
    load_from_file();  // 启动时自动加载数据
    
    do {
        show_menu();
        printf("请选择操作：");
        scanf("%d", &choice);

        switch(choice) {
            case 1: add_product(); break;
            case 2: update_stock(2); break;
            case 3: update_stock(3); break;
            case 4: display_products(); break;
            case 5: search_product_by_id(); break;  
            case 6: calculate_total_cost(); break;
            case 7: save_to_file(); break;
            case 8: load_from_file(); break;        
            case 0: printf("正在退出...\n"); break;
            default: printf("无效选择！\n");
        }
        if (choice != 0) {
            printf("按任意键继续...");
            while(getchar() != '\n'); // 清除输入缓冲区
            getchar(); // 等待按键
        }
    } while(choice != 0);

    save_to_file(); // 退出前自动保存
    free_all();     // 释放内存
    return 0;
}
