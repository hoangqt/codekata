#!/usr/bin/env bash

set -euo pipefail

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

nodemon -e go --exec "make build S=c_style_check && make run S=c_style_check" --watch "$CWD"
