#!/usr/bin/env bash

set -euo pipefail

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

nodemon -e lua --exec "lua c_style_check.lua ../c/c_style_check.c" --watch "$CWD"
