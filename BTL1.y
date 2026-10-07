%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "BTL1.h"


extern int line_num;
extern int yylex(void);
extern FILE *yyin;
void yyerror(const char *s);

ASTNode *root = NULL;
int error_count = 0;
%}

%union {
    int num_val;
    char *str_val;
    struct ASTNode *node;
}

%token BEGIN_TOK END_TOK INT_TOK BOOL_TOK STRING_TOK LONG_TOK
%token IF_TOK THEN_TOK ELSE_TOK DO_TOK WHILE_TOK FOR_TOK PRINT_TOK
%token GE LE EQ NE
%token <num_val> NUM
%token <str_val> ID STRING_LITERAL

%type <node> ChuongTr ThanCT CLenh KhaiBao GanBien
%type <node> LenhIF LenhWhile LenhFor LenhPrint TToan
%type <node> Sosanh Pheptoan So factor KieuID

%nonassoc THEN_TOK
%nonassoc ELSE_TOK

%%

// Chương trình
ChuongTr:
    BEGIN_TOK ThanCT END_TOK {
        root = create_node(NODE_PROGRAM);
        root->left = $2;
    }
;

ThanCT:
    ThanCT CLenh {
        if ($2 != NULL) {
            if ($1 == NULL) {
                $$ = create_node(NODE_STMT_LIST);
                $$->left = $2;
            } else {
                ASTNode *curr = $1;
                while (curr->next != NULL) {
                    curr = curr->next;
                }
                ASTNode *new_stmt = create_node(NODE_STMT_LIST);
                new_stmt->left = $2;
                curr->next = new_stmt;
                $$ = $1;
            }
        } else {
            $$ = $1;
        }
    }
    | /* empty */ { $$ = NULL; }
;

CLenh:
    KhaiBao ';'   { $$ = $1; }
    | GanBien ';' { $$ = $1; }
    | LenhIF       { $$ = $1; }
    | LenhWhile { $$ = $1; }
    | LenhFor      { $$ = $1; }
    | LenhPrint ';' { $$ = $1; }
    | '{' ThanCT '}' {
        $$ = create_node(NODE_BLOCK);
        $$->left = $2;
    }
    | error ';' { yyerrok; $$ = NULL; }
    | error '}' { yyerrok; $$ = NULL; }
;

// Ký tự
KieuID:
    INT_TOK  { $$ = create_node(NODE_ID); $$->op_or_name = strdup("int"); }
    | BOOL_TOK { $$ = create_node(NODE_ID); $$->op_or_name = strdup("bool"); }
    | STRING_TOK { $$ = create_node(NODE_ID); $$->op_or_name = strdup("string"); }
    | LONG_TOK { $$ = create_node(NODE_ID ); $$->op_or_name = strdup("long"); }
;

KhaiBao:
    KieuID ID {
        $$ = create_node(NODE_DECL);
        $$->op_or_name = $1->op_or_name;
        $$->left = create_node(NODE_ID);
        $$->left->op_or_name = $2;
        free($1);
    }
    | KieuID ID '=' TToan {
        $$ = create_node(NODE_DECL);
        $$->op_or_name = $1->op_or_name;
        $$->left = create_node(NODE_ID);
        $$->left->op_or_name = $2;
        $$->right = $4;
        free($1);
    }
;

GanBien:
    ID '=' TToan {
        $$ = create_node(NODE_ASSIGN);
        $$->op_or_name = $1;
        $$->left = $3;
    }
;

// Cau Lenh
LenhIF:
    IF_TOK '(' TToan ')' THEN_TOK CLenh %prec THEN_TOK {
        $$ = create_node(NODE_IF);
        $$->cond = $3;
        $$->left = $6;
    }
    | IF_TOK '(' TToan ')' THEN_TOK CLenh ELSE_TOK CLenh {
        $$ = create_node(NODE_IF);
        $$->cond = $3;
        $$->left = $6;
        $$->else_stmt = $8;
    }
;

LenhWhile:
    DO_TOK CLenh WHILE_TOK '(' TToan ')' ';' {
        $$ = create_node(NODE_DO_WHILE);
        $$->left = $2;
        $$->cond = $5;
    }
;

LenhFor:
    FOR_TOK '(' KhaiBao ';' TToan ';' GanBien ')' CLenh {
        $$ = create_node(NODE_FOR);
        $$->left = $3;
        $$->cond = $5;
        $$->step = $7;
        $$->right = $9;
    }
;

LenhPrint:
    PRINT_TOK '(' TToan ')' {
        $$ = create_node(NODE_PRINT);
        $$->left = $3;
    }
;

// Phep tinh toan
TToan:
    Sosanh { $$ = $1; }
;

Sosanh:
    Pheptoan '>' Pheptoan {
        $$ = create_node(NODE_BIN_OP); $$->op_or_name = strdup(">"); $$->left = $1; $$->right = $3;
    }
    | Pheptoan GE Pheptoan {
        $$ = create_node(NODE_BIN_OP); $$->op_or_name = strdup(">="); $$->left = $1; $$->right = $3;
    }
    | Pheptoan EQ Pheptoan {
        $$ = create_node(NODE_BIN_OP); $$->op_or_name = strdup("=="); $$->left = $1; $$->right = $3;
    }
    | Pheptoan '<' Pheptoan {
        $$ = create_node(NODE_BIN_OP); $$->op_or_name = strdup("<"); $$->left = $1; $$->right = $3;
    }
    | Pheptoan LE Pheptoan {
        $$ = create_node(NODE_BIN_OP); $$->op_or_name = strdup("<="); $$->left = $1; $$->right = $3;
    }
    | Pheptoan NE Pheptoan {
        $$ = create_node(NODE_BIN_OP); $$->op_or_name = strdup("!="); $$->left = $1; $$->right = $3;
    }
    | Pheptoan { $$ = $1; }
;

Pheptoan:
    Pheptoan '+' So {
        $$ = create_node(NODE_BIN_OP); $$->op_or_name = strdup("+"); $$->left = $1; $$->right = $3;
    }
    | Pheptoan '-' So {
        $$ = create_node(NODE_BIN_OP); $$->op_or_name = strdup("-"); $$->left = $1; $$->right = $3;
    }
    | So { $$ = $1; }
;

So:
    So '*' factor {
        $$ = create_node(NODE_BIN_OP); $$->op_or_name = strdup("*"); $$->left = $1; $$->right = $3;
    }
    | So '/' factor {
        $$ = create_node(NODE_BIN_OP); $$->op_or_name = strdup("/"); $$->left = $1; $$->right = $3;
    }
    | So '%' factor {
        $$ = create_node(NODE_BIN_OP); $$->op_or_name = strdup("%"); $$->left = $1; $$->right = $3;
    }
    | factor { $$ = $1; }
;

factor:
    ID { $$ = create_node(NODE_ID); $$->op_or_name = $1; }
    | NUM { $$ = create_node(NODE_NUM); $$->int_val = $1; }
    | STRING_LITERAL { $$ = create_node(NODE_STRING_LITERAL); $$->str_val = $1; }
    | '(' TToan ')' { $$ = $2; }
;

%%

void yyerror(const char *s) {
    error_count++;
    fprintf(stderr, "Tồn tại lỗi cú pháp tại dòng:%d: %s\n", line_num, s);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            perror("Không thể mở file nguồn");
            return 1;
        }
        yyin = file;
    } else {
        printf("Sử dụng: %s <file_nguon_upl>\n", argv[0]);
        return 1;
    }

    yyparse();

    if (error_count == 0) {
        printf("\n Cú pháp Đúng \n");
        printf(" CÂY CÚ PHÁP TRỪU TƯỢNG (AST):\n\n");
        print_ast(root, 0);
    } else {
        printf("\nCú pháp tồn tại %d sai sót\n", error_count);
    }

    return 0;
}