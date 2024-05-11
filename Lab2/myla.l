%option noyywrap
%option yylineno
%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tree.h"
#include "y.tab.h"

int col = 1;
int line = 1;
void createLeafNode(int error)
{
    int id = -1;
    char *content = malloc(strlen(yytext)+1);
    strcpy(content, yytext);
    yylval.node = createNode(id, error, content);
}
%}

ID_NONDIGIT         [A-Za-z]|"_"
ID_DIGIT            [0-9]
IDENTIFIER          {ID_NONDIGIT}({ID_NONDIGIT}|{ID_DIGIT})*

DECIMAL             [1-9][0-9]*
OCTAL               0[0-7]*
HEX_PREFIX          0x|0X
HEXADECIMAL         {HEX_PREFIX}[0-9a-fA-F]+
CONSTVALUE          {DECIMAL}|{OCTAL}|{HEXADECIMAL}

COMMENT1            "/*"[^*]*"*"+([^*/][^*]*"*"+)*"/"
COMMENT2            "//".* 
COMMENT             {COMMENT1}|{COMMENT2}
WHOLE               [a-zA-Z0-9]+

%%

"int" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return K_int;
}
"void" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return K_void;
}
"const" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return K_const;
}
"main" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return Ident;
}
"if" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return K_if;
}
"else" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return K_else;
}
"while" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return K_while;
}
"break" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return K_break;
}
"continue" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return K_continue;
}
"return" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return K_return;
}
"true" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return K_true;
}
"false" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return K_false;
}

{IDENTIFIER} {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return Ident;
}

{CONSTVALUE} {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return IntConst;
}

"+" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return O_plus;
}
"-" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return O_minus;
}
"*" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return O_multi;
}
"/" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return O_div;
}
"%" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return O_mod;
}
"=" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return O_assign;
}
"==" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return O_eq;
}
"!=" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return O_neq;
}
">"|"<"|">="|"<=" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return O_comp;
} 
"!" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return O_lnot;
}
"&&" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return O_land;
}
"||" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return O_lor;
}

"[" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return D_leftS;
}
"]" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return D_rightS;
}
"(" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return D_leftP;
}
")" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return D_rightP;
}
"{" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return D_leftB;
}
"}" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return D_rightB;
}
"," {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return D_comma;
}
";" {
    createLeafNode(0);
    col += yyleng;
    line = yylineno;
    return D_semicolon;
}

{COMMENT} {
    printf("%s: T, (%d, %d)\n", yytext, yylineno, col);
    col += yyleng;
    line = yylineno;
}

{WHOLE} {
    printf("%s: T, (%d, %d)\n", yytext, yylineno, col);
    col += yyleng;
    line = yylineno;
}

\t {
    col += 4;
    line = yylineno;
}

. {
    col += 1;
    line = yylineno;
}

\n {
    col = 1;
    line = yylineno;
}

%%
