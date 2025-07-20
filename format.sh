#!/bin/bash

# RuboCop formatting script for algorithm folder

set -euo pipefail

if [ $# -eq 0 ]; then
    echo "🔍 Running RuboCop with auto-correct (parallel)…"
    bundle exec rubocop -A --parallel
else
    echo "🔍 Running RuboCop with auto-correct (parallel) on $* …"
    bundle exec rubocop -A --parallel "$@"
fi

echo ""
echo "✅ RuboCop finished." 