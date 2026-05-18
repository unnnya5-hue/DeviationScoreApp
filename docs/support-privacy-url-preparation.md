# サポートURL・プライバシーポリシーURL準備

最終更新日: 2026-05-18

## 作成済みファイル

App Store Connectに登録するURL用に、以下の静的HTMLを作成済みです。

- `docs/index.html`
- `docs/public/support.html`
- `docs/public/privacy.html`

これらを公開できる場所に置き、URLをApp Store Connectへ入力します。

GitHub Pagesでは、リポジトリの `main` ブランチにある `/docs` フォルダを公開元にする想定です。

## 入力前に置き換えるもの

以下のプレースホルダーを実値に置き換えます。

```text
[問い合わせメールアドレスを入力]
```

置き換え対象:

- `docs/public/support.html`
- `docs/public/privacy.html`
- `docs/privacy-policy.md`
- `docs/app-store-connect-submission-values.md`

## GitHub Pagesで公開する手順

1. GitHubでこのアプリ用のリポジトリを作成する
2. ローカルリポジトリにGitHubのremoteを追加する
3. `main` ブランチをGitHubへpushする
4. GitHubのリポジトリ画面で `Settings > Pages` を開く
5. `Build and deployment` の `Source` を `Deploy from a branch` にする
6. `Branch` を `main`、フォルダを `/docs` にする
7. `Save` を押す
8. 数分後に公開URLを確認する

## URL例

GitHub Pagesで `/docs` を公開元にした場合の例:

```text
トップURL: https://unnnya5-hue.github.io/DeviationScoreApp/
サポートURL: https://unnnya5-hue.github.io/DeviationScoreApp/public/support.html
プライバシーポリシーURL: https://unnnya5-hue.github.io/DeviationScoreApp/public/privacy.html
```

独自ドメインで公開する場合の例:

```text
サポートURL: https://example.com/hensachi-asobi/support.html
プライバシーポリシーURL: https://example.com/hensachi-asobi/privacy.html
```

## 公開後の確認

- ブラウザでサポートURLが開ける
- ブラウザでプライバシーポリシーURLが開ける
- ログインなしで閲覧できる
- スマホ表示で文字が読める
- 問い合わせメールアドレスが実値になっている
- App Store Connectのメタデータと内容が矛盾していない

## App Store Connectへ入れる値

公開後、以下を `docs/app-store-connect-submission-values.md` に反映します。

```text
サポートURL:
プライバシーポリシーURL:
問い合わせメールアドレス:
```
