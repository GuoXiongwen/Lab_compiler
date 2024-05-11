#ifndef TREE_H
#define TREE_H
#include <stdio.h>
#define MAX_SECTIONS 10

typedef struct Node
{
    int id;
    int error;
    int numChildren;
    char * content;
    struct Node* children[MAX_SECTIONS];
    struct Node* parent;
    
}Node;

typedef struct GraphNode
{
    int nodeID;
    int error;
    int sectionFrom;                            // 来自父母节点的哪个部分
    int numSections;                            // 自己有多少个部分
    char* sections[MAX_SECTIONS];
    struct GraphNode* children[MAX_SECTIONS];   // 至多从每个部分引出一个子节点，如果某个部分没引出子节点，则为NULL
    struct GraphNode* parent;
}GraphNode;

Node* createNode(int id, int error,char * content);
void addChildNode(Node * parent, Node * child);

void addESC(char* dst, char* src);
void displayTreeNodes(GraphNode* root,FILE* fp);
void displayTreeEdges(GraphNode* root,FILE* fp);
void saveTreeToFile(Node* root,FILE* fp);
#endif