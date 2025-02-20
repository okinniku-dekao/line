#!/bin/bash

# SRCROOTが設定されていない場合のフォールバック
if [ -z "${SRCROOT}" ]; then
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    SRCROOT="$( cd "${SCRIPT_DIR}/.." && pwd )"
fi

# サーバーディレクトリを設定（SRCROOTの一つ上の階層のline-serverを指定）
SERVER_DIR="$( cd "${SRCROOT}/.." && pwd )/line-server"
PID_FILE="${SERVER_DIR}/.pid"

# デバッグビルドの場合のみ実行
if [ "$CONFIGURATION" == "Debug" ]; then
    echo "Starting Vapor server for debugging..."
    
    # 既存のサーバープロセスをチェックと停止
    if [ -f "$PID_FILE" ]; then
        OLD_PID=$(cat "$PID_FILE")
        if kill -0 "$OLD_PID" 2>/dev/null; then
            echo "Stopping existing server with PID: $OLD_PID"
            kill "$OLD_PID"
            sleep 2  # サーバーが完全に停止するのを待つ
        fi
        rm "$PID_FILE"
    fi
    
    # サーバーディレクトリに移動してサーバーを起動
    cd "${SERVER_DIR}"
    
    # MacOSXのSDKを明示的に指定してビルド・実行
    export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
    
    # サーバーを起動し、nohupで実行（標準出力とエラー出力をログファイルにリダイレクト）
    nohup swift run --disable-sandbox > "${SERVER_DIR}/vapor.log" 2>&1 &
    
    # PIDを保存
    SERVER_PID=$!
    echo $SERVER_PID > "$PID_FILE"
    echo "Vapor server started with PID: $SERVER_PID"
fi