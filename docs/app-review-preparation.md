# App Store審査提出準備

最終更新日: 2026-05-17

## 方針

初回リリースは、審査と素材準備の負担を減らすために以下の形で提出します。

- アプリ名: 偏差値あそび
- バージョン: `1.0`
- 対応: iPhone専用
- 画面向き: 縦画面のみ
- カテゴリ: エンターテインメント
- ログイン: なし
- 課金: なし
- 外部サーバー: なし
- 広告: Google AdMobあり
- 診断履歴: 端末内保存のみ

## 提出までの順番

1. AdMobで本番用のiOSアプリと広告ユニットを作成する（完了）
2. 本番のAdMobアプリIDと広告ユニットIDへ差し替える（完了）
3. サポートURL、プライバシーポリシーURL、問い合わせメールを用意する
4. App Store Connectにアプリ情報、価格、年齢レーティング、Appプライバシーを入力する
5. iPhone用スクリーンショットを作成する
6. Releaseビルド、実機確認、Archive、App Store Connectへアップロードを行う
7. アップロードしたビルドを選択し、App Review向けメモを添えて提出する

## App Store Connect入力メモ

### 基本情報

- Bundle ID: `com.kairi.DeviationScoreApp`
- SKU案: `deviation-score-app-ios`
- アプリ名: `偏差値あそび`
- サブタイトル案: `ネタ診断で偏差値チェック`
- カテゴリ: `エンターテインメント`
- 価格: 初回は無料

### 年齢レーティング回答の考え方

このアプリはエンタメ診断であり、暴力、性的表現、ギャンブル、医療情報、ユーザー生成コンテンツ、位置情報共有は扱いません。App Store Connectの質問では、実際の表示内容に合わせて低リスク側で回答します。

「恋愛」「婚活」などのテーマはありますが、露骨な性的表現を含めない前提です。質問文や結果文を追加する場合も、審査前は過激な表現を避けます。

### App Review向けメモ

```text
本アプリはエンターテインメント目的の簡易診断アプリです。診断結果は医学的、心理学的、学力的、採用・転職適性上の正確な評価ではありません。

ログイン、会員登録、課金、外部サーバー連携はありません。診断履歴は端末内にのみ保存されます。

広告はGoogle AdMobを利用しています。審査用ビルドでは広告ID設定後の表示確認を行っています。
```

## Appプライバシー回答メモ

App Store Connectでは、アプリ本体だけでなく、組み込んだ広告SDKなど第三者パートナーが収集するデータも回答対象です。

このアプリ本体で開発者サーバーへ送信しているもの:

- なし

端末内だけに保存しているもの:

- 診断テーマ
- 偏差値風スコア
- 結果タイトル
- 診断日時

AdMobにより申告が必要になる可能性が高いもの:

- ID: デバイスID、広告識別子など
- 使用状況データ: 広告表示、広告インタラクション、アプリ起動など
- 診断情報: クラッシュ、パフォーマンスなど
- 位置情報: IPアドレス由来のおおよその位置情報

トラッキングの扱いは、AdMobの配信設定とIDFA利用方針に合わせて決めます。パーソナライズ広告やIDFAを使う場合は、App Tracking Transparency対応と説明文の追加が必要です。

## スクリーンショット候補

初回はiPhone専用なので、iPhone向けスクリーンショットを優先して作成します。

- 1枚目: トップ画面
- 2枚目: 診断一覧画面
- 3枚目: 診断中の選択式質問
- 4枚目: 数字入力またはIQ風クイズ
- 5枚目: 結果画面
- 6枚目: 履歴画面

## 審査前の実機確認

- アプリ起動時に白画面で止まらない
- トップから診断開始できる
- 全診断のうち数件を最後まで進められる
- 数字入力のキーボードが閉じられる
- 診断中の「やめる」が動く
- 結果画面のシェアが開く
- 結果画面の「別の診断へ」が直接戻る
- 履歴から結果画面を再表示できる
- AdMobの起動時広告、診断後広告、バナーがクラッシュしない
- オフラインや広告読み込み失敗時でもアプリ本体が使える

## 公式参考

- App Store提出: https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/submit-an-app
- Appプライバシー: https://developer.apple.com/app-store/app-privacy-details/
- スクリーンショット: https://developer.apple.com/help/app-store-connect/manage-app-information/upload-app-previews-and-screenshots/
- App Review Guidelines: https://developer.apple.com/app-store/review/guidelines/
- AdMobのApp Storeデータ開示: https://developers.google.com/admob/ios/privacy/data-disclosure
