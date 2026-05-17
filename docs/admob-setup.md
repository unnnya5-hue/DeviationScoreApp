# AdMob設定メモ

最終更新日: 2026-05-17

## 現在の状態

Google Mobile Ads SDKをSwift Package Manager経由で追加し、以下の画面に広告枠を実装しています。

- トップ画面の注目診断下
- 診断一覧画面の下部
- 結果画面の下部
- 履歴画面の下部
- 設定画面の下部
- アプリ起動時のApp Open広告
- 診断完了時のインタースティシャル広告

現在は本番のAdMobアプリIDと広告ユニットIDを使用しています。

起動直後の白画面を避けるため、SDK初期化はアプリ起動時ではなく、広告バナーが初めて表示されるタイミングで行います。また、Google Mobile Ads SDKの公式手順に合わせて `Other Linker Flags` に `-ObjC` を設定しています。

## 現在の本番ID

審査提出前に以下へ差し替え済みです。

### AdMobアプリID

`iOS/DeviationScoreApp/DeviationScoreApp/Info.plist` の `GADApplicationIdentifier`:

```text
ca-app-pub-6961277874965643~9419414388
```

### バナー広告ユニットID

`iOS/DeviationScoreApp/DeviationScoreApp/AdMobBannerView.swift` の `bannerAdUnitID`:

```text
ca-app-pub-6961277874965643/3783944323
```

### App Open広告ユニットID

`iOS/DeviationScoreApp/DeviationScoreApp/AdMobBannerView.swift` の `appOpenAdUnitID`:

```text
ca-app-pub-6961277874965643/4022634932
```

### インタースティシャル広告ユニットID

`iOS/DeviationScoreApp/DeviationScoreApp/AdMobBannerView.swift` の `interstitialAdUnitID`:

```text
ca-app-pub-6961277874965643/2453568249
```

## 注意点

- 本番IDへ差し替え済みのため、審査前は実機で広告読み込み失敗時もクラッシュしないことを確認します。
- 自分の本番広告をクリックしないでください。
- テスト確認で広告を頻繁に触る場合は、一時的にGoogle公式のテスト広告IDへ戻します。
- App Store ConnectのAppプライバシー回答は広告ありの内容に更新します。
- パーソナライズ広告やIDFAを使う場合は、App Tracking Transparency対応が必要になる可能性があります。
- 公開後は、開発者Webサイトに `app-ads.txt` を設置すると広告収益の保護に役立ちます。
