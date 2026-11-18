import XCTest

/// v1.1 追加機能のUIテスト。各ステップのスクリーンショットを証跡として結果バンドルに残す。
/// 広告は起動引数 -disableAdsForUITesting で止めている（DEBUGビルドのみ有効）。
final class DeviationScoreAppUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["-disableAdsForUITesting"]
        app.launch()
    }

    // MARK: - 一覧画面

    func test01_DiagnosisListShowsFilterChipsAndNewBadges() throws {
        openDiagnosisTab()

        XCTAssertTrue(app.buttons["すべて"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["NEW"].exists)
        XCTAssertTrue(app.buttons["知識"].exists)
        XCTAssertTrue(app.searchFields.firstMatch.exists, "検索欄が表示されていない")
        capture("01-1_一覧画面_初期表示")

        let newCard = card("雑学偏差値")
        scrollTo(newCard)
        XCTAssertTrue(newCard.label.contains("新着"), "新規診断にNEWバッジがない: \(newCard.label)")
        capture("01-2_一覧画面_NEWバッジ")

        let oldCard = card("婚活偏差値")
        scrollTo(oldCard)
        XCTAssertFalse(oldCard.label.contains("新着"), "既存診断にNEWバッジが付いている")
    }

    func test02_FilterByNewShowsOnlyAddedDiagnoses() throws {
        openDiagnosisTab()
        app.buttons["NEW"].tap()

        XCTAssertTrue(card("雑学偏差値").waitForExistence(timeout: 5))
        XCTAssertFalse(card("婚活偏差値").exists, "NEW絞り込みに既存診断が出ている")
        XCTAssertFalse(card("IQ風クイズ偏差値").exists, "NEW絞り込みに既存診断が出ている")
        capture("02-1_NEW絞り込み")

        app.swipeUp()
        app.swipeUp()
        XCTAssertTrue(card("異世界転生偏差値").exists)
        capture("02-2_NEW絞り込み_下部")
    }

    func test03_FilterByCategory() throws {
        openDiagnosisTab()
        app.buttons["知識"].tap()

        XCTAssertTrue(card("IQ風クイズ偏差値").waitForExistence(timeout: 5))
        XCTAssertTrue(card("雑学偏差値").exists)
        XCTAssertTrue(card("漢字読み偏差値").exists)
        XCTAssertTrue(card("論理パズル偏差値").exists)
        XCTAssertFalse(card("婚活偏差値").exists, "知識カテゴリに恋愛の診断が出ている")
        XCTAssertFalse(card("モテ偏差値").exists, "知識カテゴリに恋愛の診断が出ている")
        capture("03-1_カテゴリ絞り込み_知識")

        app.buttons["すべて"].tap()
        XCTAssertTrue(card("婚活偏差値").waitForExistence(timeout: 5))
        capture("03-2_カテゴリ絞り込み_すべてに戻す")
    }

    func test04_SearchByKeyword() throws {
        openDiagnosisTab()

        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("異世界")

        XCTAssertTrue(card("異世界転生偏差値").waitForExistence(timeout: 5))
        XCTAssertFalse(card("婚活偏差値").exists, "検索結果に無関係な診断が出ている")
        capture("04-1_検索_異世界")

        clear(searchField)
        // 「サバイバル」はタイトルには無く、異世界転生偏差値の概要にだけ含まれる語
        searchField.typeText("サバイバル")
        XCTAssertTrue(card("異世界転生偏差値").waitForExistence(timeout: 5), "概要の文言でヒットしていない")
        XCTAssertFalse(card("婚活偏差値").exists)
        capture("04-2_検索_概要の文言でヒット")

        clear(searchField)
        searchField.typeText("存在しない診断")
        XCTAssertFalse(card("婚活偏差値").exists)
        capture("04-3_検索_該当なし")
    }

    func test05_SearchCombinedWithCategoryFilter() throws {
        openDiagnosisTab()
        app.buttons["ネタ"].tap()

        let searchField = app.searchFields.firstMatch
        searchField.tap()
        searchField.typeText("偏差値")

        XCTAssertTrue(card("陰の者偏差値").waitForExistence(timeout: 5))
        XCTAssertFalse(card("雑学偏差値").exists, "カテゴリ絞り込みと検索が併用されていない")
        capture("05-1_ネタ絞り込み＋検索")
    }

    // MARK: - 診断の回答と結果画面

    func test06_CompleteKageNoMonoShowsCustomRankAndOnePoint() throws {
        openDiagnosis("陰の者偏差値")
        capture("06-1_陰の者_1問目")
        answerAllQuestions(numberAnswer: "0", choiceID: "a", diagnosisName: "06_陰の者")

        assertResultScreen(expectedRanks: ["光属性", "陽だまりの住人", "ハイブリッド型", "陰の者", "闇の王"])
        capture("06-3_陰の者_結果画面")
        app.swipeUp()
        XCTAssertTrue(app.staticTexts["ワンポイント"].exists)
        capture("06-4_陰の者_結果画面_ワンポイント")
    }

    func test07_CompleteIsekaiShowsCustomRank() throws {
        openDiagnosis("異世界転生偏差値")
        answerAllQuestions(numberAnswer: "3", choiceID: "b", diagnosisName: "07_異世界転生")

        assertResultScreen(expectedRanks: ["初日でスライムに敗北", "村人A", "駆け出し冒険者", "Bランク冒険者", "チート級転生者"])
        capture("07-1_異世界転生_結果画面")
        app.swipeUp()
        capture("07-2_異世界転生_結果画面_下部")
    }

    func test08_LogicPuzzleShowsTimerAndClearTime() throws {
        openDiagnosis("論理パズル偏差値")

        let timer = app.staticTexts.matching(NSPredicate(format: "label MATCHES %@", "^[0-9]+:[0-9]{2}$")).firstMatch
        XCTAssertTrue(timer.waitForExistence(timeout: 5), "タイマーが表示されていない")
        capture("08-1_論理パズル_タイマー表示")

        answerAllQuestions(numberAnswer: "21", choiceID: "c", diagnosisName: "08_論理パズル")
        assertResultScreen(expectedRanks: ["チュートリアル中", "伸びしろ大盛り", "ふつうに強い", "じわじわ強い", "上位プレイヤー", "エース級", "ボス部屋前", "伝説の偏差値"])
        XCTAssertTrue(app.staticTexts["クリアタイム"].exists, "結果画面にクリアタイムがない")
        capture("08-2_論理パズル_結果画面_クリアタイム")
    }

    func test09_CompletedResultAppearsInHistory() throws {
        openDiagnosis("雑学偏差値")
        answerAllQuestions(numberAnswer: "47", choiceID: "a", diagnosisName: "09_雑学")
        assertResultScreen(expectedRanks: ["チュートリアル中", "伸びしろ大盛り", "ふつうに強い", "じわじわ強い", "上位プレイヤー", "エース級", "ボス部屋前", "伝説の偏差値"])
        capture("09-1_雑学_結果画面")

        app.tabBars.buttons["履歴"].tap()
        XCTAssertTrue(app.staticTexts["雑学偏差値"].firstMatch.waitForExistence(timeout: 5), "履歴に結果が保存されていない")
        capture("09-2_履歴画面")
    }

    func test10_SettingsShowsAppVersion() throws {
        let tab = app.tabBars.buttons["設定"]
        XCTAssertTrue(tab.waitForExistence(timeout: 10))
        tab.tap()

        // LabeledContent はラベルと値が「バージョン、1.1」のように1要素に結合される
        let version = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH %@", "バージョン")).matching(NSPredicate(format: "label CONTAINS %@", "1.1")).firstMatch
        XCTAssertTrue(version.waitForExistence(timeout: 5), "設定画面にバージョン1.1が表示されていない")
        XCTAssertFalse(app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "MVP")).firstMatch.exists)
        capture("10-1_設定画面_バージョン")
    }

    // MARK: - 広告とプライバシー

    /// トラッキングは行わないため、起動時にATTのダイアログが出ず、設定画面に広告の説明が表示されること。
    /// 広告自体は読み込まない（-disableAdsForUITesting）。同意確認だけ -testConsentFlow で動かす。
    func test11_NoTrackingDialogAndAdPrivacySettings() throws {
        app.terminate()
        app.resetAuthorizationStatus(for: .userTracking)
        app.launchArguments += ["-testConsentFlow"]
        app.launch()

        let tab = app.tabBars.buttons["設定"]
        XCTAssertTrue(tab.waitForExistence(timeout: 10))
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        XCTAssertFalse(springboard.alerts.firstMatch.waitForExistence(timeout: 5), "トラッキング許可のダイアログが表示されてしまう")
        tab.tap()

        XCTAssertTrue(app.staticTexts["広告とプライバシー"].exists || app.staticTexts["広告とプライバシー".uppercased()].exists)
        let provider = app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", "Google AdMob")).firstMatch
        XCTAssertTrue(provider.waitForExistence(timeout: 5), "広告配信の表示がない")
        XCTAssertFalse(app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH %@", "トラッキング")).firstMatch.exists, "トラッキング状態の行が残っている")
        XCTAssertFalse(app.buttons["open-settings-button"].exists)
        capture("11-1_設定画面_広告とプライバシー")
    }

    // MARK: - Helpers

    private func openDiagnosisTab() {
        let tab = app.tabBars.buttons["診断"]
        XCTAssertTrue(tab.waitForExistence(timeout: 10))
        tab.tap()
    }

    private func openDiagnosis(_ title: String) {
        openDiagnosisTab()
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText(title)

        let target = card(title)
        XCTAssertTrue(target.waitForExistence(timeout: 5), "\(title) が見つからない")
        if app.keyboards.count > 0 {
            app.keyboards.buttons["search"].firstMatch.tapIfExists()
        }
        target.tap()
        XCTAssertTrue(app.staticTexts["1 / 16"].waitForExistence(timeout: 5), "\(title) の1問目が表示されない")
    }

    private func answerAllQuestions(numberAnswer: String, choiceID: String, diagnosisName: String) {
        for index in 1...16 {
            XCTAssertTrue(app.staticTexts["\(index) / 16"].waitForExistence(timeout: 5), "\(index)問目が表示されない")

            let numberField = app.textFields["number-field"]
            if numberField.exists {
                numberField.tap()
                numberField.typeText(numberAnswer)
                // キーボード上の「次へ」で確定できること（v1.1で修正したキーボード重なり問題の確認）
                let keyboardSubmit = app.buttons["keyboard-submit"]
                XCTAssertTrue(keyboardSubmit.waitForExistence(timeout: 3), "\(index)問目: キーボード上に次へボタンがない")
                if index == 1 {
                    capture("\(diagnosisName)_数字入力_キーボード表示")
                }
                keyboardSubmit.tap()
            } else {
                let option = app.buttons["choice-option-\(choiceID)"]
                XCTAssertTrue(option.waitForExistence(timeout: 5), "\(index)問目の選択肢がない")
                if index == 6 {
                    capture("\(diagnosisName)_選択問題")
                }
                option.tap()
            }
        }
    }

    private func assertResultScreen(expectedRanks: [String]) {
        XCTAssertTrue(app.staticTexts["判定コメント"].waitForExistence(timeout: 10), "結果画面が表示されない")
        let rankShown = expectedRanks.contains { app.staticTexts[$0].exists }
        XCTAssertTrue(rankShown, "想定したランク名が表示されていない")
        XCTAssertTrue(app.staticTexts["ワンポイント"].exists, "ワンポイント欄がない")
    }

    private func card(_ title: String) -> XCUIElement {
        app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", title)).firstMatch
    }

    private func scrollTo(_ element: XCUIElement, maxSwipes: Int = 12) {
        var swipes = 0
        while !(element.exists && element.isHittable) && swipes < maxSwipes {
            app.swipeUp()
            swipes += 1
        }
        XCTAssertTrue(element.exists, "要素が見つからない")
    }

    private func clear(_ field: XCUIElement) {
        let clearButton = field.buttons.firstMatch
        if clearButton.exists {
            clearButton.tap()
        } else {
            field.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 20))
        }
    }

    private func capture(_ name: String, screenshot: XCUIScreenshot? = nil) {
        let attachment = XCTAttachment(screenshot: screenshot ?? app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

private extension XCUIElement {
    func tapIfExists() {
        if exists && isHittable {
            tap()
        }
    }
}
