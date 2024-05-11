flex myla.l
yacc -d mysa.y
gcc y.tab.c lex.yy.c tree.c -o mc -O2 -w

./mc test-examples/1.sy 1.dot
dot -Tpng -o Tree1.png 1.dot

./mc test-examples/2.sy 2.dot
dot -Tpng -o Tree2.png 2.dot

./mc test-examples/3.sy 3.dot
dot -Tpng -o Tree3.png 3.dot