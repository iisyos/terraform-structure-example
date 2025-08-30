## Description

この例では 各環境ごとに Terraform state を分離して管理しています。
また同時にモジュールも分離しており、CloudFront と S3 の 2 つのモジュールを作成しています。

- environments
  - production: [environments/production/main.tf](./environments/production/main.tf)
  - staging: [environments/staging/main.tf](./environments/staging/main.tf)
- modules
  - S3: [modules/s3](./modules/s3)
  - CloudFront: [modules/cloud-front](./modules/cloud-front)

このように、環境ごとに state が分離することは以下のようなメリットがあります。

- 誤って意図しない環境のリソースを変更・削除してしまうリスクが減少する
- 各環境への state が独立しているため、個別に apply 可能かつ、プロビジョニングや変更の適用にかかる時間が短縮される
- 新しい環境が必要になった場合に、既存の環境に影響を与えずに比較的容易に追加できる

しかし、依然として下記の課題は残ります。

- state が独立しているとはいえ、環境ごとに 1 つの state ファイルで管理するため、肥大化によるパフォーマンスの低下が発生する可能性がある
- module を相対パスで読み取っているため、作業中の module を意図しない環境に apply してしまうリスクがある
  - terraform 実行時のバージョンの module をプロビジョニングするため、誤って異なる環境に適用してしまうリスクがある

<img src="./description_1.png">

## Usage - staging 環境の例

1. バックエンドバケットの作成

```sh
BUCKET_NAME="your-unique-bucket-name" # 好きな名前に変更してください

aws s3 mb s3://$BUCKET_NAME
cat > environments/staging/backend.tfvars << EOF
bucket = "$BUCKET_NAME"
EOF
```

2. Terraform の初期化

```sh
cd environments/staging
terraform init -backend-config=backend.tfvars
```

3. Plan の実行

```sh
terraform plan
```

plan の結果例

4. Apply の実行

```sh
terraform apply
```
