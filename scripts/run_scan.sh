#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
python3 research/swing_stock_strategy.py --start 2018-01-01 --max-positions 2
