## curl
### クッキーを出力する
```
curl -X POST http://localhost:8080/api/auth/login \
-H "Content-Type: application/json" \
-d '{
    "username": "testuser",
    "password": "password123"
}' \
-c cookies.txt
```

### クッキーを指定して使う
```
curl http://localhost:8080/me \                    
-b cookies.txt
```

### アカウント作成
```
curl -X POST http://localhost:8080/api/auth/register \
-H "Content-Type: application/json" \
-d '{
    "email": "test@example.com",
    "userName": "testuser",
    "password": "password123",
    "confirmPassword": "password123",
}'
```

### ログイン
```
curl -X POST http://localhost:8080/api/auth/login \
-H "Content-Type: application/json" \
-d '{
    "email": "test@example.com",
    "password": "password123"
}'
```

## Vapor コマンド
|コマンド|説明|
|:--|:--|
|vapor build|プロジェクトをビルド|
|vapor run|アプリケーションを実行（swift run Run と同じ）|
|vapor run migrate|マイグレーションを実行|
|vapor run revert|最新のマイグレーションをロールバック|
|vapor run seed|シードデータを投入（シードスクリプトがある場合）|
|vapor run routes|現在のルート一覧を取得|
