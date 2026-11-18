# v1.1 テスト結果報告（エビデンス）

| 項目 | 内容 |
|---|---|
| 実施日 | 2026-11-18 |
| 対象 | いろいろ偏差値診断 v1.2 (build 2)・Debugビルド（App Storeで1.1が配信済みのため、リリース版は1.2として提出。作業名はv1.1のまま） |
| 端末 | iPhone 17 Pro Max シミュレータ（iOS 26.5） |
| 環境 | Xcode 26.6 / macOS 26.5.1 |
| 結果 | **34件中34件成功（失敗0・スキップ0）** |
| 生データ | `test-summary.json`（xcresulttool の結果要約） |
| 備考 | 全件実行で test01・test02 がテストランナー起動時に強制終了（signal term、アプリの不具合ではない）。2件を単独で再実行し成功 |

## テスト対象（v1.1 の変更点）

1. 診断15本の追加（合計36本）
2. 一覧画面のカテゴリ絞り込み・NEW絞り込み・キーワード検索
3. 新規診断へのNEWバッジ
4. 結果画面の文言追加（共通ランク8段階×コメント3種、陰の者・異世界転生の専用ランク、カテゴリ別ワンポイント、注意書き）
5. 論理パズル偏差値のタイマー
6. 数字入力時のキーボード上「次へ」ボタン（キーボード重なり問題の修正）
7. 設定画面のバージョン表示（「MVP 0.2」固定 → アプリのバージョンを表示）
8. 広告の同意確認（UMP）、設定画面の「広告とプライバシー」欄、プライバシーマニフェスト（トラッキング＝ATTは行わない方針）

## 結果サマリー

| 種類 | 件数 | 成功 | 失敗 |
|---|---:|---:|---:|
| 単体テスト（診断データ） `DiagnosisCatalogTests` | 9 | 9 | 0 |
| 単体テスト（採点・結果文言） `DiagnosisEngineTests` | 14 | 14 | 0 |
| UIテスト（画面操作） `DeviationScoreAppUITests` | 11 | 11 | 0 |
| **合計** | **34** | **34** | **0** |

## 単体テスト一覧

### 診断データ（`DiagnosisCatalogTests`）

| テスト | 確認内容 | 結果 |
|---|---|---|
| testCatalogContainsPublishedAndNewDiagnoses | 診断が36本あり、v1.0の21本とv1.1の15本がすべて含まれる | ✅ |
| testDiagnosisIDsAndTitlesAreUnique | 診断IDとタイトルに重複がない | ✅ |
| testQuestionIDsAreUniqueAcrossCatalog | 全質問IDに重複がない | ✅ |
| testEveryDiagnosisHasValidStructure | 全36診断で問題数16〜17、選択肢4つ・1〜4点・4点あり・文言重複なし、数字問題の満点4 | ✅ |
| testNewDiagnosisIDsMatchV11Additions | NEWバッジ対象がv1.1追加の15本と一致し、既存診断には付かない | ✅ |
| testAddedDiagnosesHaveFiveNumberAndElevenChoiceQuestions | 追加15本が「数字5問＋選択11問」の構成 | ✅ |
| testCategoriesOfAddedDiagnoses | 追加15本のカテゴリが想定どおり | ✅ |
| testQuizAnswersAreCorrect | クイズ36問（雑学・漢字読み・論理パズル・社会人マナー）で、4点の選択肢が正解の文言になっている | ✅ |
| testNumericQuizTargets | 数字のクイズ16問の正解値が正しい | ✅ |

### 採点・結果文言（`DiagnosisEngineTests`）

| テスト | 確認内容 | 結果 |
|---|---|---|
| testBestAnswersGiveMaximumDeviationForEveryDiagnosis | 全36診断で、最高の回答をすると偏差値80になる | ✅ |
| testWorstAnswersGiveLowDeviationForEveryDiagnosis | 全36診断で、最低の回答をすると偏差値20以上45未満になる | ✅ |
| testUnansweredQuestionsScoreZero | 未回答は0点（偏差値20） | ✅ |
| testResultKeepsDiagnosisInfoAndElapsedTime | 結果に診断名・カテゴリ・クリアタイムが入り、シェア文も正しい | ✅ |
| testRangeScoring / testHigherIsBetterScoring / testLowerIsBetterScoring / testExactScoring / testClosestScoring | 数字問題の採点方式5種の境界値 | ✅ |
| testCommonBandsHaveEightRanksWithThreeCommentsEach | 共通ランクが8段階で、各段階にコメントが3種（重複なし） | ✅ |
| testCustomBandsForKageNoMonoAndIsekai | 陰の者・異世界転生の専用ランク名。満点時に「闇の王」「チート級転生者」になる | ✅ |
| testResultCommentIsChosenFromBandVariations | コメントがランクの候補からランダムに選ばれる（60回中に複数種類が出る） | ✅ |
| testRankIsSelectedByDeviationBoundaries | 偏差値に応じて正しいランクが選ばれる（全17段階の回答で確認） | ✅ |
| testOnePointAdviceExistsForEveryCategoryAndTier | ワンポイントが11カテゴリ×3段階すべてにあり、境界（44/45/58）で切り替わる | ✅ |

## UIテスト一覧とスクリーンショット

広告は起動引数 `-disableAdsForUITesting` で止めて実行しました。この引数はDEBUGビルドでのみ有効で、リリース版には影響しません。

| No | テスト | 確認内容 | 結果 |
|---|---|---|---|
| 01 | test01_DiagnosisListShowsFilterChipsAndNewBadges | 絞り込みボタン・検索欄の表示。新規診断にだけNEWバッジ | ✅ |
| 02 | test02_FilterByNewShowsOnlyAddedDiagnoses | 「NEW」で追加診断だけになり、既存診断は出ない | ✅ |
| 03 | test03_FilterByCategory | 「知識」で知識カテゴリだけになる。「すべて」で元に戻る | ✅ |
| 04 | test04_SearchByKeyword | 診断名で検索できる。概要の文言でもヒットする。該当なしの表示 | ✅ |
| 05 | test05_SearchCombinedWithCategoryFilter | カテゴリ絞り込みと検索を同時に使える | ✅ |
| 06 | test06_CompleteKageNoMonoShowsCustomRankAndOnePoint | 陰の者偏差値を16問回答し、専用ランクとワンポイントが出る | ✅ |
| 07 | test07_CompleteIsekaiShowsCustomRank | 異世界転生偏差値を16問回答し、専用ランクが出る | ✅ |
| 08 | test08_LogicPuzzleShowsTimerAndClearTime | 論理パズルでタイマーが出て、結果にクリアタイムが出る | ✅ |
| 09 | test09_CompletedResultAppearsInHistory | 雑学偏差値を回答し、結果が履歴に保存される | ✅ |
| 10 | test10_SettingsShowsAppVersion | 設定画面のバージョンが「1.2」になり、「MVP」表記が出ない | ✅ |
| 11 | test11_NoTrackingDialogAndAdPrivacySettings | 初回起動でトラッキング許可ダイアログが出ない。設定画面に「広告とプライバシー」欄（広告配信: Google AdMob）が出て、トラッキング関連の表示がない | ✅ |

テスト06〜09では、数字入力の問題（各5問・計20問）をすべてキーボード上の「次へ」ボタンで回答し、キーボードを閉じなくても先へ進めることを確認しています。

### 01. 一覧画面・NEWバッジ
| 初期表示 | NEWバッジ |
|---|---|
| <img src="screenshots/01-1_一覧画面_初期表示.png" width="260"> | <img src="screenshots/01-2_一覧画面_NEWバッジ.png" width="260"> |

### 02. NEW絞り込み
| 上部 | 下部 |
|---|---|
| <img src="screenshots/02-1_NEW絞り込み.png" width="260"> | <img src="screenshots/02-2_NEW絞り込み_下部.png" width="260"> |

### 03. カテゴリ絞り込み
| 「知識」を選択 | 「すべて」に戻す |
|---|---|
| <img src="screenshots/03-1_カテゴリ絞り込み_知識.png" width="260"> | <img src="screenshots/03-2_カテゴリ絞り込み_すべてに戻す.png" width="260"> |

### 04・05. 検索
| 「異世界」 | 「サバイバル」（概要でヒット） | 該当なし | ネタ＋「偏差値」 |
|---|---|---|---|
| <img src="screenshots/04-1_検索_異世界.png" width="200"> | <img src="screenshots/04-2_検索_概要の文言でヒット.png" width="200"> | <img src="screenshots/04-3_検索_該当なし.png" width="200"> | <img src="screenshots/05-1_ネタ絞り込み＋検索.png" width="200"> |

### 06. 陰の者偏差値（専用ランク）
| 1問目（数字） | キーボード上の「次へ」 | 選択問題 | 結果画面 | ワンポイント |
|---|---|---|---|---|
| <img src="screenshots/06-1_陰の者_1問目.png" width="200"> | <img src="screenshots/06-1b_陰の者_キーボード上の次へ.png" width="200"> | <img src="screenshots/06-2_陰の者_選択問題.png" width="200"> | <img src="screenshots/06-3_陰の者_結果画面.png" width="200"> | <img src="screenshots/06-4_陰の者_結果画面_ワンポイント.png" width="200"> |

### 07. 異世界転生偏差値（専用ランク）
| 選択問題 | 結果画面 | 結果画面（下部） |
|---|---|---|
| <img src="screenshots/07-0_異世界転生_選択問題.png" width="200"> | <img src="screenshots/07-1_異世界転生_結果画面.png" width="200"> | <img src="screenshots/07-2_異世界転生_結果画面_下部.png" width="200"> |

### 08. 論理パズル偏差値（タイマー）
| タイマー表示 | 選択問題 | 結果（クリアタイム） |
|---|---|---|
| <img src="screenshots/08-1_論理パズル_タイマー表示.png" width="200"> | <img src="screenshots/08-1b_論理パズル_選択問題.png" width="200"> | <img src="screenshots/08-2_論理パズル_結果画面_クリアタイム.png" width="200"> |

### 09. 雑学偏差値と履歴
| 選択問題 | 結果画面 | 履歴画面 |
|---|---|---|
| <img src="screenshots/09-0_雑学_選択問題.png" width="200"> | <img src="screenshots/09-1_雑学_結果画面.png" width="200"> | <img src="screenshots/09-2_履歴画面.png" width="200"> |

### 10. 設定画面のバージョン表示
<img src="screenshots/10-1_設定画面_バージョン.png" width="200">

### 11. 広告とプライバシー（トラッキングなし）
このテストだけは起動引数 `-testConsentFlow` で同意確認の流れを動かしています（広告の読み込みは止めたまま）。

<img src="screenshots/11-1_設定画面_広告とプライバシー.png" width="200">

## テスト中に見つかったこと

| No | 内容 | 区分 | 対応 |
|---|---|---|---|
| 1 | 数字入力の問題で、キーボードが「決定して次へ」ボタンに重なる。利用者はまず「完了」でキーボードを閉じないと次へ進めない | **アプリの既存課題（v1.0から）** | **修正済み**。キーボード上のバーを「閉じる／次へ」（最終問題は「結果を見る」）にし、キーボードを閉じずに回答を確定できるようにした。テスト06〜09で確認 |
| 4 | 設定画面のバージョンが「MVP 0.2」のままだった | アプリの既存課題 | **修正済み**。アプリのバージョン（現在1.2）を自動表示するようにした。テスト10で確認 |
| 2 | 「質問IDは診断IDで始まる」というテストの前提が、v1.0のIQ風クイズ（`iq-like` / 質問ID `iq-1`〜）に合わなかった | テスト側の誤り | 公開済みのIDは変えず、テストで例外扱いにした |
| 3 | 「クイズ」で雑学偏差値がヒットする前提にしていたが、雑学偏差値の概要文に「クイズ」は含まれていない | テスト側の誤り | 概要にだけ含まれる語「サバイバル」で確かめるよう修正 |

1回目の実行ではNo.1〜3が原因で計3件失敗しました。No.1・4のアプリ修正後に再実行し、上記のとおり33件すべて成功しています（追加したテスト10は、ラベルと値が1要素にまとまる表示仕様に合わせて、テスト側の要素の探し方を1回修正しました）。

## 今回のテストに含まれないもの

- 実機での確認（シミュレータのみで実施）
- 広告の表示（テスト中は停止）
- UMPの同意フォーム（EEA・英国向け）の表示。AdMob管理画面で同意メッセージを作成・公開していないと表示されないため未確認。確認するときはDEBUGビルドを起動引数 `-umpDebugGeographyEEA` 付きで起動する
- 結果のシェア（共有シートを開いた後の操作）
- Releaseビルドでの動作と、App Store Connectへのアップロード
- 追加15本のうち、UIテストで最後まで回答したのは4本（陰の者・異世界転生・論理パズル・雑学）。残り11本はデータと採点を単体テストで確認しました

## 再実行の手順

```sh
cd iOS/DeviationScoreApp
xcodebuild test \
  -project DeviationScoreApp.xcodeproj \
  -scheme DeviationScoreApp \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -resultBundlePath ./TestResults.xcresult
```

スクリーンショットは結果バンドルの添付ファイルに入っています。`xcrun xcresulttool export attachments --path ./TestResults.xcresult --output-path <出力先>` で書き出せます。
