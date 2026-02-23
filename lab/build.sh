#!/bin/bash
# Build the dx→JS bootstrap compiler for browser use.
# Concatenates all pipeline stages and compiles to JavaScript.
#
# Demos using this compiler:
#   demo/babilonese.html  — Babylonian algorithm + automatic differentiation
#   demo/maze_bfs.html    — Maze BFS/DFS solver with animated visualization
set -e
cd "$(dirname "$0")/../.."

echo "Concatenating bootstrap pipeline..."
cat dx_01/tests/programs/lexer.dx \
    dx_01/tests/programs/parser.dx \
    dx_01/tests/programs/phase1.dx \
    dx_01/tests/programs/lower.dx \
    dx_01/tests/programs/emitter_js.dx \
    > /tmp/dx_compiler_full.dx

echo "Compiling to JavaScript..."
python3 -m dx_01.dx build /tmp/dx_compiler_full.dx --target js

cp /tmp/dx_compiler_full.js dx_01/demo/dx_compiler.js
echo "Written dx_01/demo/dx_compiler.js ($(wc -c < dx_01/demo/dx_compiler.js) bytes)"
