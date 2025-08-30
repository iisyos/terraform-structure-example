## Description

この例では単一の Terraform state で production 環境と staging 環境を管理しています。  
[main.tf](./main.tf)

<img src="./images/description_1.png">

全ての環境のリソースが単一の state で管理されていることは、一見便利に思えますが、以下のようなデメリットがあります。

- 環境ごとにリソースを分離できないため、誤って本番環境のリソースを変更・削除してしまうリスクがある
- state ファイルが大きくなり、プロビジョニングや変更の適用に時間がかかる
- チームでの作業時にコンフリクトが発生しやすくなる

そのためモジュールと環境ごとに ファイルを分離することが推奨されます。

<img src="./images/description_2.png">

引用元: https://charity.wtf/2016/03/30/terraform-vpc-and-why-you-want-a-tfstate-file-per-env/

## Usage

1. バックエンドバケットの作成

```sh
BUCKET_NAME="your-unique-bucket-name" # 好きな名前に変更してください

aws s3 mb s3://$BUCKET_NAME
cat > backend.tfvars << EOF
bucket = "$BUCKET_NAME"
EOF
```

2. Terraform の初期化

```sh
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
