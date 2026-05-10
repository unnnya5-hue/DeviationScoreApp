import Foundation

enum DiagnosisEngine {
    static func makeResult(for diagnosis: Diagnosis, answers: [String: DiagnosisAnswer]) -> DiagnosisResult {
        let rawScore = diagnosis.questions.reduce(0) { total, question in
            total + score(for: question, answer: answers[question.id])
        }

        let maxPoint = max(diagnosis.maxPoint, 1)
        let normalized = Double(rawScore) / Double(maxPoint)
        let deviation = Int((20 + normalized * 60).rounded())
        let band = diagnosis.bands
            .sorted { $0.minScore > $1.minScore }
            .first { deviation >= $0.minScore } ?? diagnosis.bands[0]

        return DiagnosisResult(
            id: UUID(),
            diagnosisID: diagnosis.id,
            diagnosisTitle: diagnosis.title,
            category: diagnosis.category,
            rawScore: rawScore,
            deviationScore: deviation,
            rankTitle: band.title,
            comment: band.comment,
            measuredAt: Date()
        )
    }

    private static func score(for question: DiagnosisQuestion, answer: DiagnosisAnswer?) -> Int {
        guard let answer else { return 0 }

        switch (question.input, answer) {
        case (.choice, .choice(let option)):
            return option.point
        case (.number(let config), .number(let value)):
            return scoreNumeric(value, rule: config.scoring)
        default:
            return 0
        }
    }

    private static func scoreNumeric(_ value: Double, rule: NumericScoringRule) -> Int {
        switch rule.mode {
        case .range:
            return scoreRange(value, rule: rule)
        case .higherIsBetter:
            return scoreHigher(value, rule: rule)
        case .lowerIsBetter:
            return scoreLower(value, rule: rule)
        case .exact:
            return scoreExact(value, rule: rule)
        case .closest:
            return scoreClosest(value, rule: rule)
        }
    }

    private static func scoreRange(_ value: Double, rule: NumericScoringRule) -> Int {
        let min = rule.idealMin ?? value
        let max = rule.idealMax ?? value
        let zeroBelow = rule.zeroBelow ?? min
        let zeroAbove = rule.zeroAbove ?? max

        if value >= min && value <= max {
            return rule.maxPoint
        }

        if value < min {
            return linearScore(value: value, zero: zeroBelow, full: min, maxPoint: rule.maxPoint)
        }

        return linearScore(value: value, zero: zeroAbove, full: max, maxPoint: rule.maxPoint)
    }

    private static func scoreHigher(_ value: Double, rule: NumericScoringRule) -> Int {
        linearScore(value: value, zero: rule.idealMin ?? 0, full: rule.idealMax ?? value, maxPoint: rule.maxPoint)
    }

    private static func scoreLower(_ value: Double, rule: NumericScoringRule) -> Int {
        linearScore(value: value, zero: rule.idealMax ?? value, full: rule.idealMin ?? 0, maxPoint: rule.maxPoint)
    }

    private static func scoreExact(_ value: Double, rule: NumericScoringRule) -> Int {
        let target = rule.target ?? value
        let diff = abs(value - target)

        if diff < 0.0001 { return rule.maxPoint }
        if diff <= 1 { return max(rule.maxPoint - 1, 0) }
        if diff <= 3 { return max(rule.maxPoint - 2, 0) }
        return 0
    }

    private static func scoreClosest(_ value: Double, rule: NumericScoringRule) -> Int {
        let target = rule.target ?? value
        let zeroDistance = max(rule.zeroAbove ?? 1, 0.0001)
        let distance = min(abs(value - target), zeroDistance)
        let ratio = 1 - distance / zeroDistance

        return max(0, min(rule.maxPoint, Int((ratio * Double(rule.maxPoint)).rounded())))
    }

    private static func linearScore(value: Double, zero: Double, full: Double, maxPoint: Int) -> Int {
        guard zero != full else { return maxPoint }

        let ratio = (value - zero) / (full - zero)
        let clamped = min(max(ratio, 0), 1)

        return max(0, min(maxPoint, Int((clamped * Double(maxPoint)).rounded())))
    }
}
