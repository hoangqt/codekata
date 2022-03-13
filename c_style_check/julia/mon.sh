#!/usr/bin/env bash

set -euo pipefail

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

nodemon -e jl --exec "julia c_style_check.jl ../c/c_style_check.c" --watch "$CWD"
