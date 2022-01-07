#!/usr/bin/env bash

set -euo pipefail

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

nodemon -e sh --exec "./c_style_check.sh ../c/c_style_check.c" --watch "$CWD"
