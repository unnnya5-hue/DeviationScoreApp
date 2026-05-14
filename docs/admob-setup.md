# AdMob設定メモ

最終更新日: 2026-05-14

## 現在の状態

Google Mobile Ads SDKをSwift Package Manager経由で追加し、以下の画面にバナー広告枠を実装しています。

- 診断一覧画面の下部
- 結果画面の下部

現在はGoogle公式のテスト広告IDを使用しています。AdMob審査中でも、この状態で実装確認できます。

## 本番IDへ差し替える場所

AdMobの審査が完了し、iOSアプリと広告ユニットを作成したら、以下を差し替えます。

### AdMobアプリID

Xcodeプロジェクト設定の `GADApplicationIdentifier` を、自分のAdMobアプリIDへ変更します。

現在の値:

```text
ca-app-pub-3940256099942544~1458002511
```

差し替え後の形式:

```text
ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy
```

### バナー広告ユニットID

`iOS/DeviationScoreApp/DeviationScoreApp/AdMobBannerView.swift` の `bannerAdUnitID` を、自分のバナー広告ユニットIDへ変更します。

現在の値:

```text
ca-app-pub-3940256099942544/2435281174
```

差し替え後の形式:

```text
ca-app-pub-xxxxxxxxxxxxxxxx/yyyyyyyyyy
```

## 注意点

- 開発中は必ずテスト広告IDを使います。
- 自分の本番広告をクリックしないでください。
- 本番IDへ差し替えたら、App Store ConnectのAppプライバシー回答を広告ありの内容に更新します。
- パーソナライズ広告やIDFAを使う場合は、App Tracking Transparency対応が必要になる可能性があります。
- 公開後は、開発者Webサイトに `app-ads.txt` を設置すると広告収益の保護に役立ちます。
