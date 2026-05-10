import SwiftUI

struct DiagnosisFlowView: View {
    @EnvironmentObject private var historyStore: HistoryStore
    @Environment(\.dismiss) private var dismiss

    let diagnosis: Diagnosis

    @State private var currentIndex = 0
    @State private var answers: [String: AnswerOption] = [:]
    @State private var result: DiagnosisResult?

    private var currentQuestion: DiagnosisQuestion {
        diagnosis.questions[currentIndex]
    }

    private var progress: Double {
        Double(currentIndex + 1) / Double(diagnosis.questions.count)
    }

    var body: some View {
        VStack(spacing: 18) {
            ProgressView(value: progress)
                .tint(diagnosis.category.accentColor)

            VStack(alignment: .leading, spacing: 12) {
                Text("\(currentIndex + 1) / \(diagnosis.questions.count)")
                    .font(.caption.bold())
                    .foregroundStyle(diagnosis.category.accentColor)

                Text(currentQuestion.text)
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .background(.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(spacing: 10) {
                ForEach(currentQuestion.options) { option in
                    Button {
                        select(option)
                    } label: {
                        HStack {
                            Text(option.text)
                                .font(.headline)
                            Spacer()
                            if answers[currentQuestion.id] == option {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(answerBackground(for: option))
                        .foregroundStyle(answerForeground(for: option))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle(diagnosis.shortTitle)
        .navigationBarTitleDisplayMode(.inline)
        .appBackground()
        .navigationDestination(item: $result) { result in
            ResultView(result: result) {
                dismiss()
            }
        }
    }

    private func answerBackground(for option: AnswerOption) -> Color {
        answers[currentQuestion.id] == option ? diagnosis.category.accentColor : .white.opacity(0.9)
    }

    private func answerForeground(for option: AnswerOption) -> Color {
        answers[currentQuestion.id] == option ? .white : .primary
    }

    private func select(_ option: AnswerOption) {
        answers[currentQuestion.id] = option

        if currentIndex + 1 < diagnosis.questions.count {
            withAnimation(.snappy) {
                currentIndex += 1
            }
        } else {
            let madeResult = DiagnosisEngine.makeResult(for: diagnosis, answers: answers)
            historyStore.save(madeResult)
            result = madeResult
        }
    }
}

#Preview {
    NavigationStack {
        DiagnosisFlowView(diagnosis: DiagnosisCatalog.diagnoses[0])
            .environmentObject(HistoryStore())
    }
}

