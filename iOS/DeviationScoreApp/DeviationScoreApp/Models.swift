import Foundation
import SwiftUI

enum DiagnosisCategory: String, CaseIterable, Codable, Identifiable {
    case romance = "恋愛"
    case knowledge = "知識"
    case social = "コミュ力"
    case career = "仕事"
    case jobHunt = "就活"
    case fun = "ネタ"

    var id: String { rawValue }

    var symbolName: String {
        switch self {
        case .romance:
            return "heart.text.square"
        case .knowledge:
            return "brain.head.profile"
        case .social:
            return "bubble.left.and.bubble.right"
        case .career:
            return "briefcase"
        case .jobHunt:
            return "graduationcap"
        case .fun:
            return "flame"
        }
    }

    var accentColor: Color {
        switch self {
        case .romance:
            return Color(red: 0.95, green: 0.22, blue: 0.48)
        case .knowledge:
            return Color(red: 0.35, green: 0.30, blue: 0.95)
        case .social:
            return Color(red: 0.00, green: 0.72, blue: 0.74)
        case .career:
            return Color(red: 0.08, green: 0.54, blue: 0.30)
        case .jobHunt:
            return Color(red: 0.94, green: 0.48, blue: 0.12)
        case .fun:
            return Color(red: 0.72, green: 0.20, blue: 0.86)
        }
    }

    var softColor: Color {
        switch self {
        case .romance:
            return Color(red: 1.00, green: 0.90, blue: 0.94)
        case .knowledge:
            return Color(red: 0.91, green: 0.91, blue: 1.00)
        case .social:
            return Color(red: 0.88, green: 1.00, blue: 0.98)
        case .career:
            return Color(red: 0.88, green: 0.97, blue: 0.91)
        case .jobHunt:
            return Color(red: 1.00, green: 0.94, blue: 0.86)
        case .fun:
            return Color(red: 0.98, green: 0.90, blue: 1.00)
        }
    }
}

struct AnswerOption: Identifiable, Codable, Hashable {
    let id: String
    let text: String
    let point: Int
}

enum NumericScoringMode: String, Codable, Hashable {
    case range
    case higherIsBetter
    case lowerIsBetter
    case exact
    case closest
}

struct NumericScoringRule: Codable, Hashable {
    let mode: NumericScoringMode
    let maxPoint: Int
    let idealMin: Double?
    let idealMax: Double?
    let target: Double?
    let zeroBelow: Double?
    let zeroAbove: Double?

    static func range(min: Double, max: Double, zeroBelow: Double, zeroAbove: Double, maxPoint: Int = 4) -> NumericScoringRule {
        NumericScoringRule(mode: .range, maxPoint: maxPoint, idealMin: min, idealMax: max, target: nil, zeroBelow: zeroBelow, zeroAbove: zeroAbove)
    }

    static func higher(min: Double, max: Double, maxPoint: Int = 4) -> NumericScoringRule {
        NumericScoringRule(mode: .higherIsBetter, maxPoint: maxPoint, idealMin: min, idealMax: max, target: nil, zeroBelow: min, zeroAbove: max)
    }

    static func lower(min: Double, max: Double, maxPoint: Int = 4) -> NumericScoringRule {
        NumericScoringRule(mode: .lowerIsBetter, maxPoint: maxPoint, idealMin: min, idealMax: max, target: nil, zeroBelow: min, zeroAbove: max)
    }

    static func exact(_ target: Double, maxPoint: Int = 4) -> NumericScoringRule {
        NumericScoringRule(mode: .exact, maxPoint: maxPoint, idealMin: nil, idealMax: nil, target: target, zeroBelow: nil, zeroAbove: nil)
    }

    static func closest(to target: Double, zeroDistance: Double, maxPoint: Int = 4) -> NumericScoringRule {
        NumericScoringRule(mode: .closest, maxPoint: maxPoint, idealMin: nil, idealMax: nil, target: target, zeroBelow: nil, zeroAbove: zeroDistance)
    }
}

struct NumericQuestionConfig: Codable, Hashable {
    let placeholder: String
    let unit: String
    let helperText: String
    let scoring: NumericScoringRule
}

enum QuestionInput: Codable, Hashable {
    case choice([AnswerOption])
    case number(NumericQuestionConfig)
}

enum DiagnosisAnswer: Codable, Hashable {
    case choice(AnswerOption)
    case number(Double)
}

struct DiagnosisQuestion: Identifiable, Codable, Hashable {
    let id: String
    let text: String
    let input: QuestionInput

    var maxPoint: Int {
        switch input {
        case .choice(let options):
            return options.map(\.point).max() ?? 0
        case .number(let config):
            return config.scoring.maxPoint
        }
    }

    var inputLabel: String {
        switch input {
        case .choice:
            return "SELECT"
        case .number:
            return "NUMBER"
        }
    }
}

struct ScoreBand: Identifiable, Codable, Hashable {
    let id: String
    let minScore: Int
    let title: String
    let comment: String
}

struct Diagnosis: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let shortTitle: String
    let category: DiagnosisCategory
    let summary: String
    let estimatedMinutes: Int
    let questions: [DiagnosisQuestion]
    let bands: [ScoreBand]

    var maxPoint: Int {
        questions.reduce(0) { total, question in
            total + question.maxPoint
        }
    }

    var hasNumberQuestions: Bool {
        questions.contains { question in
            if case .number = question.input {
                return true
            }
            return false
        }
    }
}

struct DiagnosisResult: Identifiable, Codable, Hashable {
    let id: UUID
    let diagnosisID: String
    let diagnosisTitle: String
    let category: DiagnosisCategory
    let rawScore: Int
    let deviationScore: Int
    let rankTitle: String
    let comment: String
    let measuredAt: Date

    var shareText: String {
        """
        \(diagnosisTitle)の結果は偏差値\(deviationScore)「\(rankTitle)」でした。
        \(comment)
        #偏差値メーカー
        """
    }
}
