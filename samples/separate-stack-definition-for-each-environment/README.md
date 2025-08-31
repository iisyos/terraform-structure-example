# 環境ごとに State を分離するパターン

## 概要

この例では、各環境ごとに Terraform state を分離して管理しています。
同時にモジュールも分離しており、CloudFront と S3 の 2 つのモジュールを作成しています。

### ディレクトリ構成

- **environments**
  - production: [environments/production/main.tf](./environments/production/main.tf)
  - staging: [environments/staging/main.tf](./environments/staging/main.tf)
- **modules**
  - S3: [modules/s3](./modules/s3)
  - CloudFront: [modules/cloud-front](./modules/cloud-front)

### メリット

環境ごとに state を分離することには、以下のようなメリットがあります：

- 誤って意図しない環境のリソースを変更・削除してしまうリスクが減少します
- 各環境への state が独立しているため、個別に apply 可能かつ、プロビジョニングや変更の適用にかかる時間が短縮されます
- 新しい環境が必要になった場合に、既存の環境に影響を与えずに比較的容易に追加できます

### 残存課題

しかし、依然として以下の課題が残ります：

- State が独立しているとはいえ、環境ごとに 1 つの state ファイルで管理するため、肥大化によるパフォーマンスの低下が発生する可能性があります
- Module を相対パスで読み取っているため、作業中の module を意図しない環境に apply してしまうリスクがあります
  - Terraform 実行時のバージョンの module をプロビジョニングするため、誤って異なる環境に適用してしまうリスクがあります

<img src="./description_1.png">

## 使用方法

### Staging 環境での実行例

#### 1. バックエンドバケットの作成

```sh
# バケット名を設定（一意の名前に変更してください）
BUCKET_NAME="your-unique-bucket-name"

aws s3 mb s3://$BUCKET_NAME
cat > environments/staging/backend.tfvars << EOF
bucket = "$BUCKET_NAME"
EOF
```

#### 2. Terraform の初期化

```sh
cd environments/staging
terraform init -backend-config=backend.tfvars
```

#### 3. Plan の実行

```sh
terraform plan
```

#### 4. Apply の実行

```sh
terraform apply
```
