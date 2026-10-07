%{
#include "BTL1.h"
#include "BTL1.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int line_num = 1;
%}

%option noyywrap

/* Comment 1 dòng */
LINE_COMMENT   "//".*

ID             [a-zA-Z]+[0-9]*
NUM            [0-9]+

%%

"\n"            { line_num++; }
[ \t\r]+        { /* Khoảng trắng */ }
{LINE_COMMENT}  { /*comment */ }

"/*"            {
                    int c;
                    while((c = input()) != 0) {
                        if(c == '\n') line_num++;
                        if(c == '*') {
                            if((c = input()) == '/') break;
                            else unput(c);
                        }
                    }
                }


"begin"         { return BEGIN_TOK; }
"end"           { return END_TOK; }
"int"           { return INT_TOK; }
"bool"          { return BOOL_TOK; }
"string" |"str" { return STRING_TOK; }
"long long"     { return LONG_TOK; }
"if"            { return IF_TOK; }
"then"          { return THEN_TOK; }
"else"          { return ELSE_TOK; }
"do"            { return DO_TOK; }
"while"         { return WHILE_TOK; }
"for"           { return FOR_TOK; }
"print"         { return PRINT_TOK; }

">="            { return GE; }
"=="            { return EQ; }
">"             { return '>'; }
"<="            { return LE; }
"<"             { return '<'; }
"!="            { return NE; }
"="             { return '='; }
"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
"%"             { return '%'; }
"("             { return '('; }
")"             { return ')'; }
"{"             { return '{'; }
"}"             { return '}'; }
";"             { return ';'; }

{NUM}           { yylval.num_val = atoi(yytext); return NUM; }
{ID}            { yylval.str_val = strdup(yytext); return ID; }

\"[^\"]*\"    {
    int len = strlen(yytext);
    yylval.str_val = (char*)malloc(len - 1);
    strncpy(yylval.str_val, yytext + 1, len - 2);
    yylval.str_val[len - 2] = '\0';
    return STRING_LITERAL;
}

.               { printf("ERROR"); }

%%