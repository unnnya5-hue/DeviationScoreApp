# AdMob設定メモ

最終更新日: 2026-05-14

## 現在の状態

Google Mobile Ads SDKをSwift Package Manager経由で追加し、以下の画面にバナー広告枠を実装しています。

- 診断一覧画面の下部
- 結果画面の下部
- アプリ起動時のApp Open広告
- 診断完了時のインタースティシャル広告

現在はGoogle公式のテスト広告IDを使用しています。AdMob審査中でも、この状態で実装確認できます。

起動直後の白画面を避けるため、SDK初期化はアプリ起動時ではなく、広告バナーが初めて表示されるタイミングで行います。また、Google Mobile Ads SDKの公式手順に合わせて `Other Linker Flags` に `-ObjC` を設定しています。

## 本番IDへ差し替える場所

AdMobの審査が完了し、iOSアプリと広告ユニットを作成したら、以下を差し替えます。

### AdMobアプリID

`iOS/DeviationScoreApp/DeviationScoreApp/Info.plist` の `GADApplicationIdentifier` を、自分のAdMobアプリIDへ変更します。

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

### App Open広告ユニットID

`iOS/DeviationScoreApp/DeviationScoreApp/AdMobBannerView.swift` の `appOpenAdUnitID` を、自分のApp Open広告ユニットIDへ変更します。

現在の値:

```text
ca-app-pub-3940256099942544/5575463023
```

### インタースティシャル広告ユニットID

`iOS/DeviationScoreApp/DeviationScoreApp/AdMobBannerView.swift` の `interstitialAdUnitID` を、自分のインタースティシャル広告ユニットIDへ変更します。

現在の値:

```text
ca-app-pub-3940256099942544/4411468910
```

## 注意点

- 開発中は必ずテスト広告IDを使います。
- 自分の本番広告をクリックしないでください。
- 本番IDへ差し替えたら、App Store ConnectのAppプライバシー回答を広告ありの内容に更新します。
- パーソナライズ広告やIDFAを使う場合は、App Tracking Transparency対応が必要になる可能性があります。
- 公開後は、開発者Webサイトに `app-ads.txt` を設置すると広告収益の保護に役立ちます。
