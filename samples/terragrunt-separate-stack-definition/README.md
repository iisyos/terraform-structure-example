## Description

このディレクトリは Terragrunt を使って環境ごと・モジュールごとに Terraform state を分離して管理する例です。
目的は、state の肥大化を防ぎつつ、環境追加やモジュール単位のデプロイを容易にすることです。

ディレクトリ構成（例）:

```
├── production
│   ├── cloud-front
│   │   └── terragrunt.hcl
│   ├── env.hcl
│   └── s3
│       └── terragrunt.hcl
└── staging
    ├── cloud-front
    │   └── terragrunt.hcl
    ├── env.hcl
    └── s3
        └── terragrunt.hcl
```

<img src="./description_1.png">

主なメリット

- 環境・モジュールごとに state を分離できるため、state の肥大化によるパフォーマンス低下を抑えられます。
- `dependency` 機能を使えば、モジュール間の依存関係を明確に定義できます。

また、恩恵を受けるのは初期開発のみですが、backend となる S3 バケットの構築も自動で行うことも可能です。
※ Usage にて S3 バケットの作成手順がないのはそのためです

開発時は `--source` オプションでモジュールの一時切り替えも可能です。つまり、GitHub からではなくローカルパスを指定してモジュールを利用できます。

https://terragrunt.gruntwork.io/docs/features/units/#terragrunt-caching

## Usage - staging 環境の例

※ハンズオンのため、TG_BUCKET_SUFFIX のような suffix を付与していますが、実際の運用では冪等性担保のためハードコードしてください。

1. plan 実行

```sh
cd environments/staging
TG_BUCKET_SUFFIX=20250831 terragrunt plan --all
```

2. apply 実行

```sh
TG_BUCKET_SUFFIX=20250831 terragrunt apply --all
```

モジュール単体を更新する場合:

```sh
cd environments/staging/s3
TG_BUCKET_SUFFIX=20250831 terragrunt apply
```

---

## How to add a new environment

1. 既存環境をコピーして新しい環境ディレクトリを作成します。

```sh
cp -r environments/staging environments/your-new-environment
```

2. `env.hcl` を編集して環境名などを設定します。

```hcl
locals {
    env = "your-new-environment"
}
```

3. 新環境の apply を実行します。

```sh
cd environments/your-new-environment
TG_BUCKET_SUFFIX=20250831 terragrunt apply --all
```
