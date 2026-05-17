# サポートURL・プライバシーポリシーURL準備

最終更新日: 2026-05-18

## 作成済みファイル

App Store Connectに登録するURL用に、以下の静的HTMLを作成済みです。

- `docs/public/support.html`
- `docs/public/privacy.html`

この2つを公開できる場所に置き、URLをApp Store Connectへ入力します。

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

## URL例

GitHub Pagesで公開する場合の例:

```text
サポートURL: https://<ユーザー名>.github.io/<リポジトリ名>/support.html
プライバシーポリシーURL: https://<ユーザー名>.github.io/<リポジトリ名>/privacy.html
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
