#!/bin/bash

set -e

export CFLAGS="-Itmp/scenariu_test_src/lib/include -std=c11 -Wall -Wextra"

# creeaza arbore temporar de test
mkdir -p tmp/scenariu_test_src/app tmp/scenariu_test_src/lib/include

# util.h
cat > tmp/scenariu_test_src/lib/include/util.h <<EOF
int util_add(int a, int b);
EOF

# util.c
cat > tmp/scenariu_test_src/lib/util.c <<EOF
#include "util.h"
int util_add(int a, int b) { return a + b; }
EOF

# main_demo.c
cat > tmp/scenariu_test_src/app/main_demo.c <<EOF
#include <stdio.h>
#include "util.h"

int main() {
    printf("%d\n", util_add(2,3));
    return 0;
}
EOF

# ruleaza build
./tools/fileops.sh build --src tmp/scenariu_test_src

# verifica executabilul
if [ ! -x bin/demo ]; then
    echo "Executabilul bin/demo nu exista"
    exit 1
fi

# ruleaza executabilul
./bin/demo > tmp/demo_out.txt

# verifica output
output=$(cat tmp/demo_out.txt)
if [ "$output" != "5" ]; then
    echo "Output incorect: $output"
    exit 1
fi

exit 0
