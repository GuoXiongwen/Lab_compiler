%option noyywrap
%option yylineno
%{

#include <stdio.h>
#include <stdlib.h>

int col = 1;

%}
TYPE                "int"|"void"
RESERVED            "const"|"main"|"if"|"else"|"else if"|"while"|"break"|"continue"|"return"
LOGIC_WORDS         "true"|"false"
KEYWORD             {TYPE}|{RESERVED}|{LOGIC_WORDS}

ID_NONDIGIT         [A-Za-z]|"_"
ID_DIGIT            [0-9]
IDENTIFIER          {ID_NONDIGIT}({ID_NONDIGIT}|{ID_DIGIT})*

DECIMAL             [1-9][0-9]*
OCTAL               0[0-7]*
HEX_PREFIX          0x|0X
HEXADECIMAL         {HEX_PREFIX}[0-9a-fA-F]+
CONSTVALUE          {DECIMAL}|{OCTAL}|{HEXADECIMAL}

ARI_OPERATOR        "+"|"-"|"*"|"%"|"/"|"="
COMPARISON          "=="|"!="|"<"|">"|"<="|">="
LOGIC_OPERATOR      "!"|"&&"|"||"
OPERATOR            {ARI_OPERATOR}|{COMPARISON}|{LOGIC_OPERATOR}

DELIMITER           "["|"]"|"("|")"|"{"|"}"|","|";"

COMMENT1            "/*"[^*]*"*"+([^*/][^*]*"*"+)*"/"
COMMENT2            "//".* 
COMMENT             {COMMENT1}|{COMMENT2}
WHOLE               [a-zA-Z0-9]+

%%

{KEYWORD} {
    printf("%s: K, (%d, %d)\n", yytext, yylineno, col);
    col += yyleng;
}

{IDENTIFIER} {
    printf("%s: I, (%d, %d)\n", yytext, yylineno, col);
    col += yyleng;
}

{CONSTVALUE} {
    printf("%s: C, (%d, %d)\n", yytext, yylineno, col);
    col += yyleng;
}

{OPERATOR} {
    printf("%s: O, (%d, %d)\n", yytext, yylineno, col);
    col += yyleng;
}

{DELIMITER} {
    printf("%s: D, (%d, %d)\n", yytext, yylineno, col);
    col += yyleng;
}

{COMMENT} {
    printf("%s: T, (%d, %d)\n", yytext, yylineno, col);
    col += yyleng;
}

{WHOLE} {
    printf("%s: T, (%d, %d)\n", yytext, yylineno, col);
    col += yyleng;
}

\t {
    col += 4;
}

. {
    col += 1;
}

\n {
    col = 1;
}

%%

int main(int argc, char *argv[]) {
    yyin = stdin;
    yylex();
    return 0;
}