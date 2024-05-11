#include "tree.h"
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
GraphNode* treeTransform(Node *root)
{
    GraphNode *mergedNode = (GraphNode *)malloc(sizeof(GraphNode));
    mergedNode->nodeID = -1;
    mergedNode->error = 0;
    mergedNode->sectionFrom = -1;
    mergedNode->numSections = root->numChildren;
    for(int i=0;i<MAX_SECTIONS;i++)
    {
        mergedNode->children[i] = NULL;
    }
    for (int i=0;i<root->numChildren;i++)
    {
        if (mergedNode->error==0 && root->children[i]->error==1)
        {
            mergedNode->error = 1;
        }
        mergedNode->sections[i] = malloc(strlen(root->children[i]->content)+1);
        strcpy(mergedNode->sections[i], root->children[i]->content);
        if (root->children[i]->numChildren > 0)
        {
            GraphNode* mergedChildNode = treeTransform(root->children[i]);
            mergedChildNode->parent = mergedNode;
            mergedChildNode->sectionFrom = i;
            mergedNode->children[i] = mergedChildNode;
        }
    }
    return mergedNode;
}

void tagTree(GraphNode* root, int* number) {
    *number += 1;
    root->nodeID = *number;
    for (int i=0;i<root->numSections;i++)
    {
        if (root->children[i] != NULL)
        {
            tagTree(root->children[i], number);
        }
    }
}

void addESC(char *dst, char *src)
{
    int i = 0;
    for (int j = 0; src[j] != '\0'; j++)
    {
        if (!isalpha(src[j]) && !isdigit(src[j]))
        {
            dst[i++] = '\\';
        }
        dst[i++] = src[j];
    }
    dst[i] = '\0';
}

Node* createNode(int id, int error,char * content)
{
    Node* node = (Node*)malloc(sizeof(Node));
    node->id = id;
    node->error = error;
    node->numChildren = 0;
    node->content = malloc(strlen(content)+1);
    strcpy(node->content, content);
    node->parent = NULL;
    for (int i=0;i<MAX_SECTIONS;i++)
    {
        node->children[i] = NULL;
    }
    return node;
}
void addChildNode(Node * parent, Node * child)
{
    // printf("AAAAAAAAAAAAAAAA\n");
    // printf("parent->numChildren: %d\n",parent->numChildren);
    parent->children[parent->numChildren++] = child;
    // printf("%p\n",child);

    // printf("%p\n",parent);
    // child->parent = parent;
    // printf("BBBBBBBBBBBBBBBB\n");
}
void displayTreeNodes(GraphNode* root, FILE* fp)
{
    // 递归遍历
    fprintf(fp,"node%d[label = \"",root->nodeID);
    for(int i=0;i<root->numSections;i++)
    {
        char transContent[100];
        addESC(transContent, root->sections[i]);
        fprintf(fp,"<f%d> %s",i,transContent);
        
        if(i!=root->numSections-1) fprintf(fp,"|");
    }
    fprintf(fp,"\"];\n");
    if (root->error)
    {
        fprintf(fp,"node%d:head[color=red];\n",root->nodeID);
    }
    // 递归
    for (int i=0;i<root->numSections;i++)
    {
        if (root->children[i] != NULL)
        {
            displayTreeNodes(root->children[i],fp);
        }
    }
}
void displayTreeEdges(GraphNode* root, FILE* fp)
{
    // 打印该节点和其子节点之间的边
    for (int i=0;i<root->numSections;i++)
    {
        if (root->children[i] != NULL)
        {
            int srcID = root->nodeID;
            int dstID = root->children[i]->nodeID;
            int secID = i;
            fprintf(fp,"\"node%d\":f%d->\"node%d\";\n",srcID,secID,dstID);
            displayTreeEdges(root->children[i], fp);
        }
    }
}

void testUnit()
{
    // 单元测试，输出到命令行
    Node* S = createNode(-1,0,"Start");
    Node* node1 = createNode(-1,0,"CompUnit");
    Node* node2 = createNode(-1,0,"LAndExp");
    Node* node9 = createNode(-1,0,"LAndExp");
    Node* node3 = createNode(-1,0,"&&");
    Node* node4 = createNode(-1,0,"EqExp");
    Node* node5 = createNode(-1,0,"LAndExp");
    Node* node6 = createNode(-1,0,"&&");
    Node* node7 = createNode(-1,0,"EqExp");
    Node* node8 = createNode(-1,0,"RelExp");
    addChildNode(S,node1);
    addChildNode(node1,node2);
    addChildNode(node2,node9);
    addChildNode(node2,node3);
    addChildNode(node2,node4);
    addChildNode(node9,node5);
    addChildNode(node9,node6);
    addChildNode(node9,node7);
    addChildNode(node4,node8);
    printf("Successfully construct tree\n");
    FILE* fp = fopen("testunit.dot", "w");
    saveTreeToFile(S,fp);
}

void saveTreeToFile(Node *startNode, FILE *fp)
{
    GraphNode * root = treeTransform(startNode);
    int *number = (int*)malloc(sizeof(int));
    *number = 0;
    tagTree(root, number);


    fprintf(fp, "digraph \" \"{\n");
    fprintf(fp, "node [shape = record, height=.1]\n");
    displayTreeNodes(root,fp);
    displayTreeEdges(root,fp);
    fprintf(fp, "}\n");
    printf("Successfully save tree information to file\n");
    return;
}
