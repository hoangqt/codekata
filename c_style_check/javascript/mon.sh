#!/usr/bin/env bash

set -euo pipefail

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

nodemon -e js --exec "node c_style_check.js ../c/c_style_check.c" --watch "$CWD"
