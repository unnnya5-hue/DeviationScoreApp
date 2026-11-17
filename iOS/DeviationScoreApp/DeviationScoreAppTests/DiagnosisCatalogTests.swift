import XCTest
@testable import DeviationScoreApp

/// 診断データ（DiagnosisCatalog）の整合性テスト。
final class DiagnosisCatalogTests: XCTestCase {
    private let publishedV10IDs: Set<String> = [
        "marriage", "iq-like", "communication", "job-change", "job-hunting", "buzz", "line-reply",
        "money-sense", "life-skill", "mental-recovery", "date-skill", "friendship", "fashion",
        "clean-room", "procrastination", "oshi-life", "travel-plan", "cooking", "karaoke",
        "crisis-avoidance", "black-history"
    ]

    private let addedV11IDs: Set<String> = [
        "trivia", "kanji-reading", "logic-puzzle", "self-esteem", "saving", "business-manners",
        "interview", "popularity", "read-the-room", "photo", "gamer", "living-alone",
        "smartphone", "kage-no-mono", "isekai"
    ]

    func testCatalogContainsPublishedAndNewDiagnoses() {
        let ids = Set(DiagnosisCatalog.diagnoses.map(\.id))

        XCTAssertEqual(DiagnosisCatalog.diagnoses.count, 36)
        XCTAssertTrue(publishedV10IDs.isSubset(of: ids), "v1.0の診断が欠けている: \(publishedV10IDs.subtracting(ids))")
        XCTAssertTrue(addedV11IDs.isSubset(of: ids), "v1.1の診断が欠けている: \(addedV11IDs.subtracting(ids))")
    }

    func testDiagnosisIDsAndTitlesAreUnique() {
        let ids = DiagnosisCatalog.diagnoses.map(\.id)
        let titles = DiagnosisCatalog.diagnoses.map(\.title)

        XCTAssertEqual(Set(ids).count, ids.count, "診断IDが重複している")
        XCTAssertEqual(Set(titles).count, titles.count, "診断タイトルが重複している")
    }

    func testQuestionIDsAreUniqueAcrossCatalog() {
        let questionIDs = DiagnosisCatalog.diagnoses.flatMap { $0.questions.map(\.id) }

        XCTAssertEqual(Set(questionIDs).count, questionIDs.count, "質問IDが重複している")
    }

    func testEveryDiagnosisHasValidStructure() {
        for diagnosis in DiagnosisCatalog.diagnoses {
            XCTAssertTrue((16...17).contains(diagnosis.questions.count), "\(diagnosis.id): 問題数 \(diagnosis.questions.count)")
            XCTAssertFalse(diagnosis.summary.isEmpty, "\(diagnosis.id): 概要が空")
            XCTAssertFalse(diagnosis.bands.isEmpty, "\(diagnosis.id): 結果ランクが空")
            XCTAssertEqual(diagnosis.bands.map(\.minScore).min(), 20, "\(diagnosis.id): 最低ランクが20から始まっていない")

            for question in diagnosis.questions {
                // v1.0 の IQ風クイズだけは質問IDの接頭辞が "iq-"（公開済みのため変更しない）
                let questionPrefix = diagnosis.id == "iq-like" ? "iq-" : diagnosis.id + "-"
                XCTAssertTrue(question.id.hasPrefix(questionPrefix), "\(question.id): 診断IDと対応していない")
                XCTAssertFalse(question.text.isEmpty, "\(question.id): 質問文が空")

                switch question.input {
                case .choice(let options):
                    XCTAssertEqual(options.count, 4, "\(question.id): 選択肢が4つではない")
                    XCTAssertEqual(Set(options.map(\.id)), ["a", "b", "c", "d"], "\(question.id): 選択肢ID")
                    XCTAssertTrue(options.allSatisfy { (1...4).contains($0.point) }, "\(question.id): 点数が1〜4の範囲外")
                    XCTAssertEqual(options.map(\.point).max(), 4, "\(question.id): 4点の選択肢がない")
                    XCTAssertEqual(Set(options.map(\.text)).count, 4, "\(question.id): 選択肢の文言が重複")
                case .number(let config):
                    XCTAssertEqual(config.scoring.maxPoint, 4, "\(question.id): 数字問題の満点")
                }
            }
        }
    }

    func testNewDiagnosisIDsMatchV11Additions() {
        XCTAssertEqual(DiagnosisCatalog.newDiagnosisIDs, addedV11IDs)

        for diagnosis in DiagnosisCatalog.diagnoses {
            XCTAssertEqual(DiagnosisCatalog.isNew(diagnosis), addedV11IDs.contains(diagnosis.id), diagnosis.id)
        }
    }

    func testAddedDiagnosesHaveFiveNumberAndElevenChoiceQuestions() {
        for diagnosis in DiagnosisCatalog.diagnoses where addedV11IDs.contains(diagnosis.id) {
            let numberCount = diagnosis.questions.filter {
                if case .number = $0.input { return true }
                return false
            }.count

            XCTAssertEqual(diagnosis.questions.count, 16, diagnosis.id)
            XCTAssertEqual(numberCount, 5, diagnosis.id)
        }
    }

    func testCategoriesOfAddedDiagnoses() {
        let expected: [String: DiagnosisCategory] = [
            "trivia": .knowledge, "kanji-reading": .knowledge, "logic-puzzle": .knowledge,
            "self-esteem": .mental, "saving": .money, "business-manners": .career, "interview": .jobHunt,
            "popularity": .romance, "read-the-room": .social, "photo": .style, "gamer": .hobby,
            "living-alone": .life, "smartphone": .fun, "kage-no-mono": .fun, "isekai": .fun
        ]

        for (id, category) in expected {
            XCTAssertEqual(DiagnosisCatalog.diagnosis(id: id)?.category, category, id)
        }
    }

    /// 正解のあるクイズは「正解4点・不正解1点」で、4点の選択肢が想定した正解になっていること。
    func testQuizAnswersAreCorrect() {
        let expectedAnswers: [String: String] = [
            "trivia-6": "黄", "trivia-7": "シェイクスピア", "trivia-8": "太陽", "trivia-9": "歩兵",
            "trivia-10": "竹や笹", "trivia-11": "鉄", "trivia-12": "12個", "trivia-13": "ロシア",
            "trivia-14": "レオナルド・ダ・ヴィンチ", "trivia-15": "紫", "trivia-16": "7色",
            "kanji-reading-6": "あいにく", "kanji-reading-7": "のどか", "kanji-reading-8": "あながち",
            "kanji-reading-9": "おはこ", "kanji-reading-10": "こわもて", "kanji-reading-11": "ようやく",
            "kanji-reading-12": "ないがしろ", "kanji-reading-13": "そうさい", "kanji-reading-14": "はんれい",
            "kanji-reading-15": "すいとう", "kanji-reading-16": "さすが",
            "logic-puzzle-6": "B", "logic-puzzle-7": "タマは動物である", "logic-puzzle-8": "箱B",
            "logic-puzzle-9": "火曜日", "logic-puzzle-10": "2個", "logic-puzzle-11": "9",
            "logic-puzzle-12": "2人", "logic-puzzle-13": "どちらもいない", "logic-puzzle-14": "3分",
            "logic-puzzle-15": "A", "logic-puzzle-16": "50円",
            "business-manners-6": "運転席の後ろ", "business-manners-7": "「田中は席を外しております」",
            "business-manners-8": "情報を共有しておきたい関係者"
        ]

        let questions = Dictionary(uniqueKeysWithValues: DiagnosisCatalog.diagnoses.flatMap(\.questions).map { ($0.id, $0) })

        for (questionID, answer) in expectedAnswers {
            guard let question = questions[questionID], case .choice(let options) = question.input else {
                XCTFail("\(questionID): 選択問題が見つからない")
                continue
            }

            XCTAssertEqual(options.filter { $0.point == 4 }.map(\.text), [answer], questionID)
            XCTAssertEqual(options.map(\.point).sorted(), [1, 1, 1, 4], "\(questionID): クイズの配点")
        }
    }

    func testNumericQuizTargets() {
        let expectedTargets: [String: Double] = [
            "trivia-1": 3776, "trivia-2": 11, "trivia-3": 333, "trivia-4": 206, "trivia-5": 47,
            "kanji-reading-1": 2, "kanji-reading-2": 5, "kanji-reading-3": 9, "kanji-reading-4": 10, "kanji-reading-5": 14,
            "logic-puzzle-1": 21, "logic-puzzle-2": 10, "logic-puzzle-3": 90, "logic-puzzle-4": 3, "logic-puzzle-5": 29,
            "business-manners-3": 3
        ]

        let questions = Dictionary(uniqueKeysWithValues: DiagnosisCatalog.diagnoses.flatMap(\.questions).map { ($0.id, $0) })

        for (questionID, target) in expectedTargets {
            guard let question = questions[questionID], case .number(let config) = question.input else {
                XCTFail("\(questionID): 数字問題が見つからない")
                continue
            }

            XCTAssertEqual(config.scoring.target, target, questionID)
        }
    }
}
