# Terraform Structure Example

## 概要

Terraform のプロジェクト構成についての例を示します。
構成はシンプルに `CloudFront` と `S3` の 2 つのリソースを作成するものとします。
また、環境は本番環境（production）とステージング環境（staging）の 2 つを想定します。

<img src="./architecture.png">

## 構成パターン一覧

- **単一 state に全環境を含むパターン** - [samples/one-stack-with-all-the-environments](./samples/one-stack-with-all-the-environments/README.md)
- **環境ごとに state を分離するパターン** - [samples/separate-stack-definition-for-each-environment](./samples/separate-stack-definition-for-each-environment/README.md)
- **環境ごとに state を分離し、モジュールをバージョニングするパターン** - [samples/separate-stack-definition-for-each-environment-versioining](./samples/separate-stack-definition-for-each-environment-versioining/README.md)
- **Terragrunt を使用した環境・モジュール分離パターン** - [samples/terragrunt-separate-stack-definition](./samples/terragrunt-separate-stack-definition/README.md)
- **Terragrunt Stack Catalog を使用したパターン** - [samples/terragrunt-stack-catalog](./samples/terragrunt-stack-catalog/README.md)
