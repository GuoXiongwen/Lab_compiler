%{
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tree.h"
void yyerror(char *s);
int yylex();
Node* root = NULL;
extern int col;
extern int line;
%}

%union
{
    struct Node* node;
}

%token <node> IntConst
%token <node> Ident
%token <node> O_plus O_minus O_multi O_div O_mod
%token <node> O_assign
%token <node> O_eq O_neq O_comp
%token <node> O_lnot O_land O_lor
%token <node> D_leftS D_rightS D_leftP D_rightP D_leftB D_rightB
%token <node> D_comma D_semicolon
%token <node> K_int K_void K_const
%token <node> K_if K_else K_while K_break K_continue
%token <node> K_return
%token <node> K_true K_false

%token <node> IFX
%nonassoc IFX
%nonassoc K_else

%type <node> Start
%type <node> CompUnit
%type <node> Decl
%type <node> ConstDecl ConstDefList ConstDef
%type <node> ConstArrayDef ConstValDef ConstInitValList ConstInitVal
%type <node> ConstDimList DimList
%type <node> VarDecl VarDefList VarDef
%type <node> VarArrayDef VarValDef InitValList InitVal
%type <node> FuncDef FuncFParams FuncFParam
%type <node> Block BlockItemList BlockItem Stmt
%type <node> Exp Cond LVal PrimaryExp Number
%type <node> UnaryExp UnaryOp
%type <node> FuncRParams
%type <node> MulExp AddExp RelExp EqExp
%type <node> LAndExp LOrExp ConstExp

%%
Start :
    CompUnit {
        $$ = createNode(-1,0,"Start");
        root = $$;
        addChildNode($$,$1);
    }
;

CompUnit :
    Decl {
        $$ = createNode(-1,0,"CompUnit");
        addChildNode($$,$1);
    }
    | CompUnit Decl {
        $$ = createNode(-1,0,"CompUnit");
        addChildNode($$,$1);
        addChildNode($$,$2);
    }
    | FuncDef {
        $$ = createNode(-1,0,"CompUnit");
        addChildNode($$,$1);
    }
    | CompUnit FuncDef {
        $$ = createNode(-1,0,"CompUnit");
        addChildNode($$,$1);
        addChildNode($$,$2);
    }
;

Decl :
    ConstDecl {
        $$ = createNode(-1,0,"Decl");
        addChildNode($$,$1);
    }
    | VarDecl {
        $$ = createNode(-1,0,"Decl");
        addChildNode($$,$1);
    }
;

ConstDecl :
    K_const K_int  ConstDefList D_semicolon {
        $$ = createNode(-1,0,"ConstDecl");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
        addChildNode($$,$4);
    }
;

ConstDefList :
    ConstDefList D_comma ConstDef {
        $$ = createNode(-1,0,"ConstDefList");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
    | ConstDef {
        $$ = createNode(-1,0,"ConstDefList");
        addChildNode($$,$1);
    }
;

ConstDef :
    ConstArrayDef {
        $$ = createNode(-1,0,"ConstDef");
        addChildNode($$,$1);
    }
    | ConstValDef {
        $$ = createNode(-1,0,"ConstDef");
        addChildNode($$,$1);
    }
    | error {
        $$ = createNode(-1,1,"ConstDef");
    }
;

ConstArrayDef :
    Ident ConstDimList O_assign D_leftB D_rightB {
        $$ = createNode(-1,0,"ConstArrayDef");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
        addChildNode($$,$4);
        addChildNode($$,$5);
    }
    | Ident ConstDimList O_assign D_leftB ConstInitValList D_rightB {
        $$ = createNode(-1,0,"ConstArrayDef");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
        addChildNode($$,$4);
        addChildNode($$,$5);
        addChildNode($$,$6);
    }
;

ConstValDef :
    Ident O_assign ConstInitVal {
        $$ = createNode(-1,0,"ConstValDef");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
;

ConstDimList :
    ConstDimList D_leftS ConstExp D_rightS {
        $$ = createNode(-1,0,"ConstDimList");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
        addChildNode($$,$4);
    }
    | D_leftS ConstExp D_rightS {
        $$ = createNode(-1,0,"ConstDimList");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
;

DimList :
    DimList D_leftS Exp D_rightS {
        $$ = createNode(-1,0,"DimList");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
        addChildNode($$,$4);
    }
    | D_leftS Exp D_rightS {
        $$ = createNode(-1,0,"DimList");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
;

ConstInitValList :
    ConstInitValList D_comma ConstInitVal {
        $$ = createNode(-1,0,"ConstInitValList");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
    | ConstInitVal {
        $$ = createNode(-1,0,"ConstInitValList");
        addChildNode($$,$1);
    }
;

ConstInitVal :
    ConstExp {
        $$ = createNode(-1,0,"ConstInitVal");
        addChildNode($$,$1);
    }
;

VarDecl :
    K_int VarDefList D_semicolon {
        $$ = createNode(-1,0,"VarDecl");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
;

VarDefList :
    VarDefList D_comma VarDef {
        $$ = createNode(-1,0,"VarDefList");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
    | VarDef {
        $$ = createNode(-1,0,"VarDefList");
        addChildNode($$,$1);
    }
;

VarDef :
    VarArrayDef {
        $$ = createNode(-1,0,"VarDef");
        addChildNode($$,$1);
    }
    | VarValDef {
        $$ = createNode(-1,0,"VarDef");
        addChildNode($$,$1);
    }
    | error {
        $$ = createNode(-1,1,"VarDef");
    }
    
VarArrayDef :
    Ident ConstDimList {
        $$ = createNode(-1,0,"VarArrayDef");
        addChildNode($$,$1);
        addChildNode($$,$2);
    }
    | Ident ConstDimList O_assign D_leftB D_rightB {
        $$ = createNode(-1,0,"VarArrayDef");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
        addChildNode($$,$4);
        addChildNode($$,$5);
    }
    | Ident ConstDimList O_assign D_leftB InitValList D_rightB {
        $$ = createNode(-1,0,"VarArrayDef");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
        addChildNode($$,$4);
        addChildNode($$,$5);
        addChildNode($$,$6);
    }
;

VarValDef :
    Ident {
        $$ = createNode(-1,0,"VarValDef");
        addChildNode($$,$1);
    }
    | Ident O_assign InitVal {
        $$ = createNode(-1,0,"VarValDef");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
;

InitValList :
    InitValList D_comma InitVal {
        $$ = createNode(-1,0,"InitValList");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
    | InitVal {
        $$ = createNode(-1,0,"InitValList");
        addChildNode($$,$1);
    }
;

InitVal : 
    Exp {
        $$ = createNode(-1,0,"InitVal");
        addChildNode($$,$1);
    }
;

FuncDef :
    K_int Ident D_leftP FuncFParams D_rightP Block {
        $$ = createNode(-1,0,"FuncDef");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
        addChildNode($$,$4);
        addChildNode($$,$5);
        addChildNode($$,$6);
    }
    | K_int Ident D_leftP D_rightP Block {
        $$ = createNode(-1,0,"FuncDef");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
        addChildNode($$,$4);
        addChildNode($$,$5);
    }
    | K_void Ident D_leftP FuncFParams D_rightP Block {
        $$ = createNode(-1,0,"FuncDef");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
        addChildNode($$,$4);
        addChildNode($$,$5);
        addChildNode($$,$6);
    }
    | K_void Ident D_leftP D_rightP Block {
        $$ = createNode(-1,0,"FuncDef");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
        addChildNode($$,$4);
        addChildNode($$,$5);
    }
;

FuncFParams :
    FuncFParams D_comma FuncFParam {
        $$ = createNode(-1,0,"FuncFParams");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
    | FuncFParam {
        $$ = createNode(-1,0,"FuncFParams");
        addChildNode($$,$1);
    }
;

FuncFParam :
    K_int Ident {
        $$ = createNode(-1,0,"FuncFParam");
        addChildNode($$,$1);
        addChildNode($$,$2);
    }
    | K_int Ident D_leftS D_rightS {
        $$ = createNode(-1,0,"FuncFParam");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
        addChildNode($$,$4);
    }
    | K_int Ident D_leftS D_rightS DimList {
        $$ = createNode(-1,0,"FuncFParam");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
        addChildNode($$,$4);
        addChildNode($$,$5);
    }
    | error {
        $$ = createNode(-1,1,"FuncFParam");
    }
;

Block :
    D_leftB BlockItemList D_rightB {
        $$ = createNode(-1,0,"Block");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
    | D_leftB D_rightB {
        $$ = createNode(-1,0,"Block");
        addChildNode($$,$1);
        addChildNode($$,$2);
    }
;

BlockItemList :
    BlockItemList BlockItem {
        $$ = createNode(-1,0,"BlockItemList");
        addChildNode($$,$1);
        addChildNode($$,$2);
    }
    | BlockItem {
        $$ = createNode(-1,0,"BlockItemList");
        addChildNode($$,$1);
    }
;

BlockItem :
    Decl {
        $$ = createNode(-1,0,"BlockItem");
        addChildNode($$,$1);
    }
    | Stmt {
        $$ = createNode(-1,0,"BlockItem");
        addChildNode($$,$1);
    }
;

Stmt :
    LVal O_assign Exp D_semicolon {
        $$ = createNode(-1,0,"Stmt");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
        addChildNode($$,$4);
    }
    | Exp D_semicolon {
        $$ = createNode(-1,0,"Stmt");
        addChildNode($$,$1);
        addChildNode($$,$2);
    }
    | D_semicolon {
        $$ = createNode(-1,0,"Stmt");
        addChildNode($$,$1);
    }
    | Block {
        $$ = createNode(-1,0,"Stmt");
        addChildNode($$,$1);
    }
    | K_if D_leftP Cond D_rightP Stmt %prec IFX {
        $$ = createNode(-1,0,"Stmt");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
        addChildNode($$,$4);
        addChildNode($$,$5);
    }
    | K_if D_leftP Cond D_rightP Stmt K_else Stmt {
        $$ = createNode(-1,0,"Stmt");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
        addChildNode($$,$4);
        addChildNode($$,$5);
        addChildNode($$,$6);
        addChildNode($$,$7);
    }
    | K_while D_leftP Cond D_rightP Stmt {
        $$ = createNode(-1,0,"Stmt");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
        addChildNode($$,$4);
        addChildNode($$,$5);
    }
    | K_break D_semicolon {
        $$ = createNode(-1,0,"Stmt");
        addChildNode($$,$1);
        addChildNode($$,$2);
    }
    | K_continue D_semicolon {
        $$ = createNode(-1,0,"Stmt");
        addChildNode($$,$1);
        addChildNode($$,$2);
    }
    | K_return D_semicolon {
        $$ = createNode(-1,0,"Stmt");
        addChildNode($$,$1);
        addChildNode($$,$2);
    }
    | K_return Exp D_semicolon {
        $$ = createNode(-1,0,"Stmt");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
    | error {
        $$ = createNode(-1,1,"Stmt");
    }
;

Exp :
    AddExp {
        $$ = createNode(-1,0,"Exp");
        addChildNode($$,$1);
    }
;

Cond :
    LOrExp {
        $$ = createNode(-1,0,"Cond");
        addChildNode($$,$1);
    }
;

LVal :
    Ident {
        $$ = createNode(-1,0,"LVal");
        addChildNode($$,$1);
    }
    | Ident DimList {
        $$ = createNode(-1,0,"LVal");
        addChildNode($$,$1);
        addChildNode($$,$2);
    }
;

PrimaryExp :
    D_leftP Exp D_rightP {
        $$ = createNode(-1,0,"PrimaryExp");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
    | LVal {
        $$ = createNode(-1,0,"PrimaryExp");
        addChildNode($$,$1);
    }
    | Number {
        $$ = createNode(-1,0,"PrimaryExp");
        addChildNode($$,$1);
    }
;

Number :
    IntConst {
        $$ = createNode(-1,0,"Number");
        addChildNode($$,$1);
    }
;

UnaryExp :
    PrimaryExp {
        $$ = createNode(-1,0,"UnaryExp");
        addChildNode($$,$1);
    }
    | Ident D_leftP D_rightP {
        $$ = createNode(-1,0,"UnaryExp");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
    | Ident D_leftP FuncRParams D_rightP {
        $$ = createNode(-1,0,"UnaryExp");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
        addChildNode($$,$4);
    }
    | UnaryOp UnaryExp {
        $$ = createNode(-1,0,"UnaryExp");
        addChildNode($$,$1);
        addChildNode($$,$2);
    }
;

UnaryOp :
    O_plus {
        $$ = createNode(-1,0,"UnaryOp");
        addChildNode($$,$1);
    }
    | O_minus {
        $$ = createNode(-1,0,"UnaryOp");
        addChildNode($$,$1);
    }
    | O_lnot {
        $$ = createNode(-1,0,"UnaryOp");
        addChildNode($$,$1);
    }
;

FuncRParams :
    FuncRParams D_comma Exp {
        $$ = createNode(-1,0,"FuncRParams");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
    | Exp {
        $$ = createNode(-1,0,"FuncRParams");
        addChildNode($$,$1);
    }
;

MulExp :
    UnaryExp {
        $$ = createNode(-1,0,"MulExp");
        addChildNode($$,$1);
    }
    | MulExp O_multi UnaryExp {
        $$ = createNode(-1,0,"MulExp");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
    | MulExp O_div UnaryExp {
        $$ = createNode(-1,0,"MulExp");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
    | MulExp O_mod UnaryExp {
        $$ = createNode(-1,0,"MulExp");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
;

AddExp :
    MulExp {
        $$ = createNode(-1,0,"AddExp");
        addChildNode($$,$1);
    }
    | AddExp O_plus MulExp {
        $$ = createNode(-1,0,"AddExp");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
    | AddExp O_minus MulExp {
        $$ = createNode(-1,0,"AddExp");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
;

RelExp :
    AddExp {
        $$ = createNode(-1,0,"RelExp");
        addChildNode($$,$1);
    }
    | RelExp O_comp AddExp {
        $$ = createNode(-1,0,"RelExp");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
    | error {
        $$ = createNode(-1,1,"RelExp");
    }
;

EqExp :
    RelExp {
        $$ = createNode(-1,0,"EqExp");
        addChildNode($$,$1);
    }
    | EqExp O_eq RelExp {
        $$ = createNode(-1,0,"EqExp");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
    | EqExp O_neq RelExp {
        $$ = createNode(-1,0,"EqExp");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
;

LAndExp :
    EqExp {
        $$ = createNode(-1,0,"LAndExp");
        addChildNode($$,$1);
    }
    | LAndExp O_land EqExp {
        $$ = createNode(-1,0,"LAndExp");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
;

LOrExp :
    LAndExp {
        $$ = createNode(-1,0,"LOrExp");
        addChildNode($$,$1);
    }
    | LOrExp O_lor LAndExp {
        $$ = createNode(-1,0,"LOrExp");
        addChildNode($$,$1);
        addChildNode($$,$2);
        addChildNode($$,$3);
    }
;

ConstExp :
    AddExp {
        $$ = createNode(-1,0,"ConstExp");
        addChildNode($$,$1);
    }
;

%%

void yyerror(char* s){
    fprintf(stderr, "%d:%d: error: %s\n", line, col, s);
}

int main(int argc, char** argv)
{
    freopen(argv[1], "r", stdin);
    yyparse();
    FILE* fp = fopen(argv[2], "w");
    
    saveTreeToFile(root, fp);
    return 0;
}