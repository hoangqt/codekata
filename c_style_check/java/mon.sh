#!/usr/bin/env bash

set -euo pipefail

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

nodemon -e java --exec "javac CStyleCheck.java && java CStyleCheck ../c/c_style_check.c" --watch "$CWD"
