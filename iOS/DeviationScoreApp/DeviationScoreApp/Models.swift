import Foundation
import SwiftUI

enum DiagnosisCategory: String, CaseIterable, Codable, Identifiable {
    case romance = "恋愛"
    case knowledge = "知識"
    case social = "コミュ力"

    var id: String { rawValue }

    var symbolName: String {
        switch self {
        case .romance:
            return "heart.text.square"
        case .knowledge:
            return "brain.head.profile"
        case .social:
            return "bubble.left.and.bubble.right"
        }
    }

    var accentColor: Color {
        switch self {
        case .romance:
            return .pink
        case .knowledge:
            return .indigo
        case .social:
            return .teal
        }
    }
}

struct AnswerOption: Identifiable, Codable, Hashable {
    let id: String
    let text: String
    let point: Int
}

struct DiagnosisQuestion: Identifiable, Codable, Hashable {
    let id: String
    let text: String
    let options: [AnswerOption]
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
            total + (question.options.map(\.point).max() ?? 0)
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
