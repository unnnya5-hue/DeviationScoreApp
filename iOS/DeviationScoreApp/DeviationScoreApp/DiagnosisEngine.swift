import Foundation

enum DiagnosisEngine {
    static func makeResult(for diagnosis: Diagnosis, answers: [String: AnswerOption]) -> DiagnosisResult {
        let rawScore = diagnosis.questions.reduce(0) { total, question in
            total + (answers[question.id]?.point ?? 0)
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
}

