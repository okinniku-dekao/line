#!/bin/bash

# SRCROOTが設定されていない場合のフォールバック
if [ -z "${SRCROOT}" ]; then
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    SRCROOT="$( cd "${SCRIPT_DIR}/.." && pwd )"
fi

SERVER_DIR="${SRCROOT}/line-server"
PID_FILE="${SERVER_DIR}/.pid"

echo $SERVER_DIR

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        echo "Stopping Vapor server (PID: $PID)..."
        kill "$PID"
        rm "$PID_FILE"
    fi
fi