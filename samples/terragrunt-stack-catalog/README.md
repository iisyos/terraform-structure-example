# Terragrunt Stack Catalog ハンズオン資料

## 概要

このディレクトリは、Terragrunt の `stack` 機能を使用して、環境・モジュールごとに Terraform state を分離しつつ、DRY（Don't Repeat Yourself）原則に基づいて管理するためのサンプルです。

### 用語定義

- **Unit**: 単一のデプロイ単位。直接 Terraform モジュールを参照し、最小のインフラコンポーネントを表します
- **Stack**: 複数の Unit（または他の Stack）を組み合わせて構成されるインフラのサブセット（例: CloudFront + S3）

### ディレクトリ構成例

```
.
├── environments
│   ├── production
│   │   └── terragrunt.stack.hcl
│   └── staging
│       └── terragrunt.stack.hcl
├── root.hcl
├── stacks
│   └── cloud-front-s3-service
│       └── terragrunt.stack.hcl
└── units
    ├── cloud-front
    │   └── terragrunt.hcl
    └── s3
        └── terragrunt.hcl
```

<img src="./description_1.png">

### 主なメリット

- 事前に Stack を定義しておくことで、環境ごとに同じ構成を簡単に適用できます
- モジュールの組み合わせを Stack 化することで、よく使うパターン（例: CloudFront + S3）を再利用可能になります

---

## 使用方法

### Staging 環境での実行例

> **注意**: ハンズオンのため `TG_BUCKET_SUFFIX` のような suffix を付与していますが、実際の運用では冪等性を担保するためハードコードすることを推奨します。

#### 1. Plan の実行

```sh
cd environments/staging
TG_BUCKET_SUFFIX=20250831 terragrunt stack run plan
```

#### 2. Apply の実行

```sh
TG_BUCKET_SUFFIX=20250831 terragrunt stack run apply
```

#### 3. モジュール単体の更新

生成されたスタックを直接操作する場合：

```sh
TG_BUCKET_SUFFIX=20250831 terragrunt generate
cd .terragrunt-stack/staging/cloud-front
terragrunt apply
```

---

## 新規環境の追加方法

### 手順

#### 1. 既存環境のコピー

既存の環境をベースに新しいディレクトリを作成します：

```sh
cp -r environments/staging environments/your-new-environment
```

#### 2. 設定ファイルの編集

`environments/your-new-environment/terragrunt.stack.hcl` を編集し、`path` や `values` を新しい環境に合わせて修正します。

#### 3. 新環境での実行

新環境で plan/apply を実行します：

```sh
cd environments/your-new-environment
TG_BUCKET_SUFFIX=20250831 terragrunt stack run plan
TG_BUCKET_SUFFIX=20250831 terragrunt stack run apply
```
