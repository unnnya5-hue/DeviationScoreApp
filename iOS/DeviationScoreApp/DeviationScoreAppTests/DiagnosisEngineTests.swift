import XCTest
@testable import DeviationScoreApp

/// 採点ロジック（DiagnosisEngine）と結果文言のテスト。
final class DiagnosisEngineTests: XCTestCase {
    // MARK: - 全診断の満点・最低点

    func testBestAnswersGiveMaximumDeviationForEveryDiagnosis() {
        for diagnosis in DiagnosisCatalog.diagnoses {
            let result = DiagnosisEngine.makeResult(for: diagnosis, answers: bestAnswers(for: diagnosis))

            XCTAssertEqual(result.rawScore, diagnosis.maxPoint, diagnosis.id)
            XCTAssertEqual(result.deviationScore, 80, diagnosis.id)
        }
    }

    func testWorstAnswersGiveLowDeviationForEveryDiagnosis() {
        for diagnosis in DiagnosisCatalog.diagnoses {
            let result = DiagnosisEngine.makeResult(for: diagnosis, answers: worstAnswers(for: diagnosis))

            XCTAssertGreaterThanOrEqual(result.deviationScore, 20, diagnosis.id)
            XCTAssertLessThan(result.deviationScore, 45, diagnosis.id)
        }
    }

    func testUnansweredQuestionsScoreZero() {
        let diagnosis = try! XCTUnwrap(DiagnosisCatalog.diagnosis(id: "trivia"))
        let result = DiagnosisEngine.makeResult(for: diagnosis, answers: [:])

        XCTAssertEqual(result.rawScore, 0)
        XCTAssertEqual(result.deviationScore, 20)
    }

    func testResultKeepsDiagnosisInfoAndElapsedTime() {
        let diagnosis = try! XCTUnwrap(DiagnosisCatalog.diagnosis(id: "logic-puzzle"))
        let result = DiagnosisEngine.makeResult(for: diagnosis, answers: bestAnswers(for: diagnosis), elapsedSeconds: 75)

        XCTAssertEqual(result.diagnosisID, "logic-puzzle")
        XCTAssertEqual(result.diagnosisTitle, "論理パズル偏差値")
        XCTAssertEqual(result.category, .knowledge)
        XCTAssertEqual(result.elapsedTimeText, "1:15")
        XCTAssertTrue(result.shareText.contains("論理パズル偏差値の結果は偏差値80"))
        XCTAssertTrue(result.shareText.contains("#いろいろ偏差値診断"))
    }

    // MARK: - 数字問題の採点ルール

    func testRangeScoring() {
        let rule = NumericScoringRule.range(min: 10, max: 20, zeroBelow: 0, zeroAbove: 40)

        XCTAssertEqual(score(rule, 15), 4)
        XCTAssertEqual(score(rule, 10), 4)
        XCTAssertEqual(score(rule, 20), 4)
        XCTAssertEqual(score(rule, 5), 2)
        XCTAssertEqual(score(rule, 30), 2)
        XCTAssertEqual(score(rule, 0), 0)
        XCTAssertEqual(score(rule, 100), 0)
    }

    func testHigherIsBetterScoring() {
        let rule = NumericScoringRule.higher(min: 0, max: 8)

        XCTAssertEqual(score(rule, 0), 0)
        XCTAssertEqual(score(rule, 4), 2)
        XCTAssertEqual(score(rule, 8), 4)
        XCTAssertEqual(score(rule, 20), 4)
    }

    func testLowerIsBetterScoring() {
        let rule = NumericScoringRule.lower(min: 2, max: 10)

        XCTAssertEqual(score(rule, 0), 4)
        XCTAssertEqual(score(rule, 2), 4)
        XCTAssertEqual(score(rule, 6), 2)
        XCTAssertEqual(score(rule, 10), 0)
        XCTAssertEqual(score(rule, 50), 0)
    }

    func testExactScoring() {
        let rule = NumericScoringRule.exact(21)

        XCTAssertEqual(score(rule, 21), 4)
        XCTAssertEqual(score(rule, 22), 3)
        XCTAssertEqual(score(rule, 18), 2)
        XCTAssertEqual(score(rule, 25), 0)
    }

    func testClosestScoring() {
        let rule = NumericScoringRule.closest(to: 3776, zeroDistance: 300)

        XCTAssertEqual(score(rule, 3776), 4)
        XCTAssertEqual(score(rule, 3626), 2)
        XCTAssertEqual(score(rule, 4076), 0)
        XCTAssertEqual(score(rule, 1000), 0)
    }

    // MARK: - 結果ランクとコメント

    func testCommonBandsHaveEightRanksWithThreeCommentsEach() {
        let bands = try! XCTUnwrap(DiagnosisCatalog.diagnosis(id: "marriage")).bands

        XCTAssertEqual(bands.map(\.minScore), [20, 38, 45, 52, 58, 65, 70, 76])
        XCTAssertEqual(bands.map(\.title), ["チュートリアル中", "伸びしろ大盛り", "ふつうに強い", "じわじわ強い", "上位プレイヤー", "エース級", "ボス部屋前", "伝説の偏差値"])

        for band in bands {
            XCTAssertEqual(band.commentVariations.count, 3, band.id)
            XCTAssertEqual(Set(band.commentVariations).count, 3, "\(band.id): コメントが重複")
        }
    }

    func testCustomBandsForKageNoMonoAndIsekai() {
        let kage = try! XCTUnwrap(DiagnosisCatalog.diagnosis(id: "kage-no-mono"))
        let isekai = try! XCTUnwrap(DiagnosisCatalog.diagnosis(id: "isekai"))

        XCTAssertEqual(kage.bands.map(\.title), ["光属性", "陽だまりの住人", "ハイブリッド型", "陰の者", "闇の王"])
        XCTAssertEqual(isekai.bands.map(\.title), ["初日でスライムに敗北", "村人A", "駆け出し冒険者", "Bランク冒険者", "チート級転生者"])

        XCTAssertEqual(DiagnosisEngine.makeResult(for: kage, answers: bestAnswers(for: kage)).rankTitle, "闇の王")
        XCTAssertEqual(DiagnosisEngine.makeResult(for: isekai, answers: bestAnswers(for: isekai)).rankTitle, "チート級転生者")
    }

    func testResultCommentIsChosenFromBandVariations() {
        let diagnosis = try! XCTUnwrap(DiagnosisCatalog.diagnosis(id: "gamer"))
        let topBand = try! XCTUnwrap(diagnosis.bands.max { $0.minScore < $1.minScore })
        var seenComments = Set<String>()

        for _ in 0..<60 {
            let result = DiagnosisEngine.makeResult(for: diagnosis, answers: bestAnswers(for: diagnosis))
            XCTAssertEqual(result.rankTitle, topBand.title)
            XCTAssertTrue(topBand.commentVariations.contains(result.comment))
            seenComments.insert(result.comment)
        }

        XCTAssertGreaterThan(seenComments.count, 1, "コメントがランダムに切り替わっていない")
    }

    func testRankIsSelectedByDeviationBoundaries() {
        let diagnosis = try! XCTUnwrap(DiagnosisCatalog.diagnosis(id: "saving"))
        let bands = diagnosis.bands.sorted { $0.minScore < $1.minScore }

        for answeredCount in 0...diagnosis.questions.count {
            var answers = worstAnswers(for: diagnosis)
            for question in diagnosis.questions.prefix(answeredCount) {
                answers[question.id] = bestAnswers(for: diagnosis)[question.id]
            }

            let result = DiagnosisEngine.makeResult(for: diagnosis, answers: answers)
            let expected = bands.last { result.deviationScore >= $0.minScore }
            XCTAssertEqual(result.rankTitle, expected?.title, "偏差値\(result.deviationScore)")
        }
    }

    // MARK: - ワンポイント

    func testOnePointAdviceExistsForEveryCategoryAndTier() {
        for category in DiagnosisCategory.allCases {
            let low = category.onePointAdvice(for: 30)
            let middle = category.onePointAdvice(for: 50)
            let high = category.onePointAdvice(for: 70)

            XCTAssertEqual(Set([low, middle, high]).count, 3, category.rawValue)
            XCTAssertFalse(low.isEmpty || middle.isEmpty || high.isEmpty, category.rawValue)
            XCTAssertEqual(category.onePointAdvice(for: 44), low, "\(category.rawValue): 44は低い帯")
            XCTAssertEqual(category.onePointAdvice(for: 45), middle, "\(category.rawValue): 45は中間帯")
            XCTAssertEqual(category.onePointAdvice(for: 58), high, "\(category.rawValue): 58は高い帯")
        }
    }

    // MARK: - Helpers

    private func score(_ rule: NumericScoringRule, _ value: Double) -> Int {
        let diagnosis = Diagnosis(
            id: "test",
            title: "テスト",
            shortTitle: "テスト",
            category: .fun,
            summary: "テスト",
            estimatedMinutes: 1,
            questions: [
                DiagnosisQuestion(
                    id: "test-1",
                    text: "数字",
                    input: .number(NumericQuestionConfig(placeholder: "", unit: "", helperText: "", scoring: rule))
                )
            ],
            bands: [ScoreBand(id: "only", minScore: 20, title: "only", comment: "only")]
        )

        return DiagnosisEngine.makeResult(for: diagnosis, answers: ["test-1": .number(value)]).rawScore
    }

    private func bestAnswers(for diagnosis: Diagnosis) -> [String: DiagnosisAnswer] {
        var answers: [String: DiagnosisAnswer] = [:]

        for question in diagnosis.questions {
            switch question.input {
            case .choice(let options):
                answers[question.id] = .choice(options.max { $0.point < $1.point }!)
            case .number(let config):
                answers[question.id] = .number(bestValue(for: config.scoring))
            }
        }

        return answers
    }

    private func worstAnswers(for diagnosis: Diagnosis) -> [String: DiagnosisAnswer] {
        var answers: [String: DiagnosisAnswer] = [:]

        for question in diagnosis.questions {
            switch question.input {
            case .choice(let options):
                answers[question.id] = .choice(options.min { $0.point < $1.point }!)
            case .number(let config):
                answers[question.id] = .number(worstValue(for: config.scoring))
            }
        }

        return answers
    }

    private func bestValue(for rule: NumericScoringRule) -> Double {
        switch rule.mode {
        case .range, .lowerIsBetter:
            return rule.idealMin!
        case .higherIsBetter:
            return rule.idealMax!
        case .exact, .closest:
            return rule.target!
        }
    }

    private func worstValue(for rule: NumericScoringRule) -> Double {
        switch rule.mode {
        case .range:
            return rule.zeroAbove! + 1000
        case .higherIsBetter:
            return rule.idealMin!
        case .lowerIsBetter:
            return rule.idealMax!
        case .exact:
            return rule.target! + 1000
        case .closest:
            return rule.target! + rule.zeroAbove!
        }
    }
}
