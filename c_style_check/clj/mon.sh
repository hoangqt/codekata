#!/usr/bin/env bash

set -euo pipefail

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

nodemon -e clj --exec "clj -M src/clj/core.clj src/clj/c_style_check.c" --watch "$CWD"
