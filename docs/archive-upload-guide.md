# ArchiveとApp Store Connectアップロード手順

最終更新日: 2026-05-18

## 事前チェック

- Bundle ID: `com.kairi.DeviationScoreApp`
- Version: `1.0`
- Build: `1`
- Signing Team: Apple Developer Program登録済みチーム
- 対応端末: iPhone専用
- 画面向き: 縦画面のみ
- AdMob本番ID: 反映済み
- App Store Connectにアプリ作成済み

## XcodeでArchiveする

1. Xcodeで `DeviationScoreApp.xcodeproj` を開く
2. Schemeが `DeviationScoreApp` になっていることを確認
3. Run Destinationを `Any iOS Device (arm64)` または実機にする
4. `Product > Clean Build Folder` を実行
5. `Product > Archive` を実行
6. Organizerが開くまで待つ

## App Store Connectへアップロード

1. Organizerで作成したArchiveを選択
2. `Distribute App` を押す
3. `App Store Connect` を選ぶ
4. `Upload` を選ぶ
5. 自動署名で進める
6. Validationを通過することを確認
7. Upload完了後、App Store Connectに反映されるまで待つ

## App Store Connectでビルドを選択する

1. App Store Connectで対象アプリを開く
2. `TestFlight` または提出するバージョンを開く
3. アップロードしたビルドが処理完了になるまで待つ
4. `iOS 1.0` のビルド欄で該当ビルドを選択
5. 暗号化の質問が出た場合は、標準HTTPS等のみで独自暗号化を使っていない前提で回答
6. App Review情報、スクリーンショット、プライバシー回答を確認
7. `審査へ提出` を実行

## よくある詰まりどころ

### Archiveが選べない

Run DestinationがSimulatorになっている可能性があります。`Any iOS Device (arm64)` を選びます。

### Signingで止まる

XcodeのSigning & Capabilitiesで、Teamが正しく選択されているか確認します。Bundle IDがApple Developerで登録済みかも確認します。

### ビルドがApp Store Connectに出ない

アップロード後、処理完了まで時間がかかる場合があります。App Store ConnectのTestFlight画面で処理状況を確認します。

### 広告が出ない

公開前、本番広告はすぐに配信されない場合があります。広告が出ないこと自体より、広告読み込み失敗時に白画面やクラッシュがないことを確認します。

## 提出前の最終確認

- アプリ起動で白画面停止しない
- 診断が最後まで進む
- 結果画面が表示される
- 履歴から結果を再表示できる
- シェアシートが開く
- 広告が読み込めない状態でもクラッシュしない
- プライバシーポリシーURLが外部から見られる
- サポートURLが外部から見られる
- Appプライバシー回答と実装が矛盾していない
