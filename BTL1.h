#ifndef AST_H
#define AST_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum {
    NODE_PROGRAM, NODE_STMT_LIST, NODE_DECL, NODE_ASSIGN,
    NODE_IF, NODE_DO_WHILE, NODE_FOR, NODE_PRINT,
    NODE_BIN_OP, NODE_ID, NODE_NUM, NODE_BLOCK, NODE_STRING_LITERAL
} NodeType;

typedef struct ASTNode {
    NodeType type;
    char* op_or_name;       /* Tên biến, toán tử, hoặc kiểu dữ liệu */
    int int_val;            /* Giá trị số nguyên */
    char* str_val;          /* Giá trị chuỗi */
    struct ASTNode *left;
    struct ASTNode *right;
    struct ASTNode *next;   /* câu lệnh */
    struct ASTNode *cond;   /* if / while / for */
    struct ASTNode *else_stmt; /* else */
    struct ASTNode *step;   /* for */
} ASTNode;

ASTNode* create_node(NodeType type);
void print_ast(ASTNode* node, int indent);
void free_ast(ASTNode* node);

#endif