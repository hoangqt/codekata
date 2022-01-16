#!/usr/bin/env bash

set -euo pipefail

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

nodemon -e cpp --exec "cmake --build build -- -j3 && ./build/c_style_check ../c/c_style_check.c" --watch "$CWD"
