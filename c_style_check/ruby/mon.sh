#!/usr/bin/env bash

set -euo pipefail

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

nodemon -e rb --exec "ruby c_style_check.rb ../c/c_style_check.c" --watch "$CWD"
