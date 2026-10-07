#include "BTL1.h"

ASTNode* create_node(NodeType type) {
    ASTNode* node = (ASTNode*)calloc(1, sizeof(ASTNode));
    node->type = type;
    return node;
}

void print_indent(int indent) {
    for (int i = 0; i < indent; i++) printf("  ");
}

void print_ast(ASTNode* node, int indent) {
    if (!node) return;

    ASTNode* curr = node;
    while (curr) {
    print_indent(indent);

    switch (curr->type) {
        case NODE_PROGRAM:
            printf("Program\n");
            print_ast(curr->left, indent + 1);
            break;
        case NODE_STMT_LIST:
            print_ast(curr->left, indent);
            break;
        case NODE_DECL:
            printf("Declaration (Type: %s, Var: %s)\n", curr->op_or_name, curr->left ? curr->left->op_or_name : "");
            if (curr->right) {
                print_indent(indent + 1);
                printf("Init Value:\n");
                print_ast(curr->right, indent + 2);
            }
            break;
        case NODE_ASSIGN:
            printf("Assignment (Var: %s)\n", curr->op_or_name);
            print_ast(curr->left, indent + 1);
            break;
        case NODE_IF:
            printf("IfStmt\n");
            print_indent(indent + 1); printf("Condition:\n");
            print_ast(curr->cond, indent + 2);
            print_indent(indent + 1); printf("Then:\n");
            print_ast(curr->left, indent + 2);
            if (curr->else_stmt) {
                print_indent(indent + 1); printf("Else:\n");
                print_ast(curr->else_stmt, indent + 2);
            }
            break;
        case NODE_DO_WHILE:
            printf("DoWhileStmt\n");
            print_indent(indent + 1); printf("Body:\n");
            print_ast(curr->left, indent + 2);
            print_indent(indent + 1); printf("Condition:\n");
            print_ast(curr->cond, indent + 2);
            break;
        case NODE_FOR:
            printf("ForStmt\n");
            print_indent(indent + 1); printf("Init:\n");
            print_ast(curr->left, indent + 2);
            print_indent(indent + 1); printf("Condition:\n");
            print_ast(curr->cond, indent + 2);
            print_indent(indent + 1); printf("Step:\n");
            print_ast(curr->step, indent + 2);
            print_indent(indent + 1); printf("Body:\n");
            print_ast(curr->right, indent + 2);
            break;
        case NODE_PRINT:
            printf("PrintStmt\n");
            print_ast(curr->left, indent + 1);
            break;
        case NODE_BIN_OP:
            printf("BinaryOp (%s)\n", curr->op_or_name);
            print_ast(curr->left, indent + 1);
            print_ast(curr->right, indent + 1);
            break;
        case NODE_ID:
            printf("Identifier (%s)\n", curr->op_or_name);
            break;
        case NODE_NUM:
            printf("Number (%d)\n", curr->int_val);
            break;
        case NODE_STRING_LITERAL:
            printf("String Literal (%s)\n", curr->str_val);
            break;
        case NODE_BLOCK:
            printf("Block\n");
            print_ast(curr->left, indent + 1);
            break;
    }
    if (curr->type == NODE_PROGRAM) break;
    curr = curr->next;
    }   
} 

void free_ast(ASTNode* node) {
    if (!node) return;
    if (node->op_or_name) free(node->op_or_name);
    free_ast(node->left);
    free_ast(node->right);
    free_ast(node->next);
    free_ast(node->cond);
    free_ast(node->else_stmt);
    free_ast(node->step);
    free(node);
}