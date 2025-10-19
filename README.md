# TechBookStore - 技術専門書店在庫管理システム

技術専門書に特化した書店向け在庫管理システム。Java 8 + Spring Boot 2.3.x + React 16.13.x のレガシー技術スタックで実装。

## システム概要

技術専門書に特化した書店向け在庫管理システムです。以下の主要機能を提供します：

- 書籍管理（ISBN-13、技術カテゴリ、レベル管理）
- 在庫管理（店頭・倉庫在庫、バーコードスキャン対応）
- 発注管理（自動発注提案、承認ワークフロー）
- 顧客管理（購買履歴、スキルマップ生成）
- 分析・レポート（売上分析、技術トレンド）

## 技術スタック

### バックエンド
- Java 8
- Spring Boot 2.3.12.RELEASE
- Spring Data JPA 2.3.9
- Spring Security 5.3.9
- Maven 3.6.3
- Swagger 2.9.2

### データベース（環境別）
- **開発環境**: H2 Database 1.4.200（インメモリ）
- **プレ本番環境**: PostgreSQL 12.x
- **本番環境**: Azure Database for PostgreSQL 11

### キャッシュ・セッション
- **開発環境**: Redis 7.x（Dev Container内で自動起動）
- **本番環境**: Azure Cache for Redis

### フロントエンド
- React 16.13.1
- Redux 4.0.5
- Material-UI 4.11.4
- Axios 0.19.2

### 開発・デプロイ
- Docker & Docker Compose
- GitHub Actions (CI/CD)
- Azure Container Apps
- VSCode Dev Containers

## 開発環境セットアップ

### 1. Dev Container を使用（推奨）

```bash
# リポジトリをクローン
git clone https://github.com/shinyay/legacy-spring-boot-23-app.git
cd legacy-spring-boot-23-app

# VSCode で開く
code .

# Command Palette (Ctrl+Shift+P) で以下を実行:
# "Dev Containers: Reopen in Container"
```

#### VS Code エディタ設定

**Dev Container環境を使用している場合、以下の設定は自動的に行われます。**

Java開発のためのVS Code設定は、Dev Container起動時に自動的に構成されます。`.vscode/settings.json`ファイルが自動生成され、適切なJava Homeパスが設定されます。

**自動起動サービス（Dev Container）：**
- PostgreSQL 12（ポート5432）
- Redis 7-alpine（ポート6379）
- Azure Storage Emulator (Azurite)（ポート10000-10002）

これらのサービスはDev Container起動時に自動的に開始され、アプリケーションから利用可能になります。

**ローカル環境での手動設定：**

ローカル環境で開発する場合は、プロジェクトルートに`.vscode/settings.json`ファイルを手動で作成してください：

```json
{
    "java.jdt.ls.java.home": "/usr/local/sdkman/candidates/java/current"
}
```

**設定手順（ローカル環境のみ）：**

1. プロジェクトルートに`.vscode`ディレクトリを作成
2. 上記の内容で`settings.json`ファイルを作成
3. Java Home パスは環境に合わせて調整してください

**一般的なJava Homeパス：**
- Dev Container環境: `/usr/local/sdkman/candidates/java/current`
- macOS (Homebrew): `/opt/homebrew/opt/openjdk@8`
- Linux (apt): `/usr/lib/jvm/java-8-openjdk-amd64`
- Windows: `C:\Program Files\Java\jdk1.8.0_XXX`

**確認方法：**
```bash
# 現在のJAVA_HOMEを確認
echo $JAVA_HOME

# Javaバージョンを確認
java -version
```

### 2. ローカル環境でのセットアップ

#### 前提条件
- Java 8
- Maven 3.6.3+
- Node.js 12.x
- Docker & Docker Compose

#### バックエンド起動

```bash
cd backend
./mvnw spring-boot:run
```

- アプリケーション: http://localhost:8080
- Swagger UI: http://localhost:8080/swagger-ui.html
- H2 Console: http://localhost:8080/h2-console

#### フロントエンド起動

```bash
cd frontend
npm install
npm start
```

- アプリケーション: http://localhost:3000

### 3. 自動起動スクリプト（推奨）

BackendとFrontendを同時に起動・管理するためのスクリプトを提供しています。

#### アプリケーション起動

```bash
# Backend と Frontend を同時に起動
./start-app.sh
```

#### アプリケーション停止

```bash
# Backend と Frontend を同時に停止
./stop-app.sh

# ログファイルも削除する場合
./stop-app.sh --clean-logs
```

#### ステータス確認

```bash
# アプリケーションの状態を確認
./status-app.sh
```

## API エンドポイント

### 書籍管理
- `GET /api/v1/books` - 書籍一覧（ページング・検索対応）
- `GET /api/v1/books/{id}` - 書籍詳細
- `POST /api/v1/books` - 書籍登録
- `PUT /api/v1/books/{id}` - 書籍更新
- `DELETE /api/v1/books/{id}` - 書籍削除

### 在庫管理
- `GET /api/v1/inventory` - 在庫一覧
- `GET /api/v1/inventory/{bookId}` - 書籍別在庫
- `POST /api/v1/inventory/receive` - 入荷処理
- `POST /api/v1/inventory/sell` - 販売処理
- `GET /api/v1/inventory/alerts` - 在庫アラート一覧

## ビルド・テスト

### バックエンド

```bash
cd backend

# ビルド
./mvnw clean compile

# テスト実行
./mvnw test

# パッケージ作成
./mvnw clean package
```

### フロントエンド

```bash
cd frontend

# 依存関係インストール
npm install

# 開発サーバー起動
npm start

# ビルド
npm run build

# テスト実行
npm test

# Lint実行
npm run lint
```

### Docker ビルド

```bash
# アプリケーション全体をビルド
docker build -t techbookstore:latest .

# 開発環境起動（Dev Container用）
cd .devcontainer
docker-compose up -d
```

## デプロイ

### 環境設定

以下の環境変数を設定してください：

```bash
# 開発環境
export SPRING_PROFILES_ACTIVE=dev

# プレ本番環境
export SPRING_PROFILES_ACTIVE=staging
export DB_USERNAME=postgres
export DB_PASSWORD=your_password

# 本番環境
export SPRING_PROFILES_ACTIVE=prod
export AZURE_POSTGRESQL_HOST=your_azure_host
export AZURE_POSTGRESQL_DATABASE=your_database
export AZURE_POSTGRESQL_USERNAME=your_username
export AZURE_POSTGRESQL_PASSWORD=your_password
```

### GitHub Actions

CI/CDパイプラインは自動で実行されます：

- `main` ブランチ → 本番環境デプロイ
- `develop` ブランチ → ステージング環境デプロイ
- Pull Request → テスト実行

#### 必要なSecrets

GitHub リポジトリの Settings > Secrets で以下を設定：

- `AZURE_CREDENTIALS` - Azureサービスプリンシパル認証情報
- `ACR_LOGIN_SERVER` - Azure Container Registry URL
- `ACR_USERNAME` - ACR ユーザー名
- `ACR_PASSWORD` - ACR パスワード
- `AZURE_RG` - Azure リソースグループ名

## 開発ガイド

### プロジェクト構成

```
legacy-spring-boot-23-app/
├── backend/                 # Spring Boot アプリケーション
│   ├── src/main/java/
│   │   └── com/techbookstore/app/
│   │       ├── entity/      # JPA エンティティ
│   │       ├── repository/  # Spring Data JPA リポジトリ
│   │       ├── controller/  # REST コントローラー
│   │       ├── dto/         # データ転送オブジェクト
│   │       └── config/      # 設定クラス
│   └── src/main/resources/
│       ├── application.yml  # アプリケーション設定
│       └── data.sql        # 初期データ（SQL）
├── frontend/                # React アプリケーション
│   ├── src/
│   │   ├── components/      # React コンポーネント
│   │   ├── store/          # Redux ストア
│   │   └── services/       # API サービス
│   └── public/
├── .devcontainer/          # Dev Container 設定
├── .github/workflows/      # GitHub Actions
├── start-app.sh           # アプリケーション起動スクリプト
├── stop-app.sh            # アプリケーション停止スクリプト
├── status-app.sh          # ステータス確認スクリプト
└── Dockerfile             # プロダクション用 Docker イメージ
```

### データベース設計

主要なエンティティ：

- `Book` - 書籍マスタ
- `Author` - 著者情報
- `Publisher` - 出版社情報
- `TechCategory` - 技術カテゴリ（階層構造）
- `Inventory` - 在庫情報
- `BookAuthor` - 書籍-著者関連
- `BookCategory` - 書籍-カテゴリ関連

## トラブルシューティング

### よくある問題

#### H2 データベースに接続できない
- アプリケーションが起動していることを確認
- `SPRING_PROFILES_ACTIVE=dev` が設定されていることを確認
- H2 Console: http://localhost:8080/h2-console
  - JDBC URL: `jdbc:h2:mem:testdb`
  - ユーザー名: `sa`
  - パスワード: (空)

#### フロントエンドでAPI呼び出しエラー
- バックエンドが起動していることを確認（http://localhost:8080）
- プロキシ設定が正しいことを確認（package.json の `"proxy": "http://localhost:8080"`）

#### Docker ビルドエラー
- Docker が起動していることを確認
- 十分なディスク容量があることを確認
- Node.js とMaven の依存関係キャッシュをクリア

## ライセンス

Released under the [MIT license](https://gist.githubusercontent.com/shinyay/56e54ee4c0e22db8211e05e70a63247e/raw/f3ac65a05ed8c8ea70b653875ccac0c6dbc10ba1/LICENSE)

## 著者

- github: <https://github.com/shinyay>
- twitter: <https://twitter.com/yanashin18618>
- mastodon: <https://mastodon.social/@yanashin>
