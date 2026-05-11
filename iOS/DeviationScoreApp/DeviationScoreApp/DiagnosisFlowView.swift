import SwiftUI

struct DiagnosisFlowView: View {
    @EnvironmentObject private var historyStore: HistoryStore
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isNumberFocused: Bool

    let diagnosis: Diagnosis

    @State private var currentIndex = 0
    @State private var answers: [String: DiagnosisAnswer] = [:]
    @State private var numberText = ""
    @State private var result: DiagnosisResult?
    @State private var shouldDismissFlowAfterResult = false
    @State private var timerStartedAt: Date?
    @State private var elapsedSeconds = 0

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var currentQuestion: DiagnosisQuestion {
        diagnosis.questions[currentIndex]
    }

    private var progress: Double {
        Double(currentIndex + 1) / Double(diagnosis.questions.count)
    }

    private var tracksElapsedTime: Bool {
        diagnosis.id == "iq-like"
    }

    private var numericValue: Double? {
        let cleaned = numberText
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "，", with: "")

        return Double(cleaned)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                stageHeader

                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text(currentQuestion.inputLabel)
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(diagnosis.category.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        Spacer()

                        Text("\(currentIndex + 1) / \(diagnosis.questions.count)")
                            .font(.caption.bold())
                            .monospacedDigit()
                            .foregroundStyle(diagnosis.category.accentColor)
                    }

                    Text(currentQuestion.text)
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .background(.white.opacity(0.92))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: diagnosis.category.accentColor.opacity(0.12), radius: 12, y: 6)

                inputView

                HStack(spacing: 10) {
                    Button {
                        moveBack()
                    } label: {
                        Label("戻る", systemImage: "chevron.left")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .disabled(currentIndex == 0)

                    Button {
                        returnToDiagnosisList()
                    } label: {
                        Label("やめる", systemImage: "xmark")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 4)
            }
            .padding()
        }
        .navigationTitle("STAGE \(currentIndex + 1)")
        .navigationBarTitleDisplayMode(.inline)
        .appBackground()
        .onAppear {
            loadNumberDraft()
            startTimerIfNeeded()
        }
        .onChange(of: currentIndex) { _, _ in
            loadNumberDraft()
        }
        .onReceive(timer) { now in
            guard tracksElapsedTime, result == nil, let timerStartedAt else { return }
            elapsedSeconds = Int(now.timeIntervalSince(timerStartedAt))
        }
        .navigationDestination(item: $result) { result in
            ResultView(result: result) {
                returnToDiagnosisList()
            }
        }
        .onChange(of: result) { _, newValue in
            guard shouldDismissFlowAfterResult, newValue == nil else { return }

            shouldDismissFlowAfterResult = false
            dismiss()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("完了") {
                    isNumberFocused = false
                }
            }
        }
    }

    private var stageHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(diagnosis.title, systemImage: diagnosis.category.symbolName)
                    .font(.headline)
                    .foregroundStyle(diagnosis.category.accentColor)
                Spacer()
                Text("\(Int((progress * 100).rounded()))%")
                    .font(.caption.bold())
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }

            if tracksElapsedTime {
                Label(DiagnosisResult.formatElapsedTime(elapsedSeconds), systemImage: "timer")
                    .font(.caption.bold())
                    .monospacedDigit()
                    .foregroundStyle(diagnosis.category.accentColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.white.opacity(0.78))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white.opacity(0.7))
                    RoundedRectangle(cornerRadius: 8)
                        .fill(diagnosis.category.accentColor)
                        .frame(width: max(12, proxy.size.width * progress))
                }
            }
            .frame(height: 12)
        }
        .padding()
        .background(diagnosis.category.softColor.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    @ViewBuilder
    private var inputView: some View {
        switch currentQuestion.input {
        case .choice(let options):
            choiceInput(options)
        case .number(let config):
            numberInput(config)
        }
    }

    private func choiceInput(_ options: [AnswerOption]) -> some View {
        VStack(spacing: 10) {
            ForEach(options) { option in
                Button {
                    select(option)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: selected(option) ? "checkmark.seal.fill" : "circle")
                            .font(.title3)
                        Text(option.text)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "chevron.right")
                            .font(.caption.bold())
                            .opacity(selected(option) ? 1 : 0.35)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(selected(option) ? diagnosis.category.accentColor : .white.opacity(0.92))
                    .foregroundStyle(selected(option) ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func numberInput(_ config: NumericQuestionConfig) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                TextField("", text: $numberText)
                    .font(.system(size: 44, weight: .black, design: .rounded))
                    .monospacedDigit()
                    .keyboardType(.decimalPad)
                    .focused($isNumberFocused)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 14)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                if !config.unit.isEmpty {
                    Text(config.unit)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                        .frame(minWidth: 44, alignment: .leading)
                }
            }

            Button {
                submitNumber()
            } label: {
                Label(currentIndex + 1 == diagnosis.questions.count ? "結果を見る" : "決定して次へ", systemImage: "checkmark.seal.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .tint(diagnosis.category.accentColor)
            .disabled(numericValue == nil)
        }
        .padding()
        .background(.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func selected(_ option: AnswerOption) -> Bool {
        guard case .choice(let selectedOption) = answers[currentQuestion.id] else {
            return false
        }

        return selectedOption == option
    }

    private func select(_ option: AnswerOption) {
        answers[currentQuestion.id] = .choice(option)
        moveForward()
    }

    private func submitNumber() {
        guard let numericValue else { return }

        isNumberFocused = false
        answers[currentQuestion.id] = .number(numericValue)
        moveForward()
    }

    private func moveForward() {
        if currentIndex + 1 < diagnosis.questions.count {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                currentIndex += 1
            }
        } else {
            let madeResult = DiagnosisEngine.makeResult(
                for: diagnosis,
                answers: answers,
                elapsedSeconds: tracksElapsedTime ? elapsedSeconds : nil
            )
            historyStore.save(madeResult)
            result = madeResult
        }
    }

    private func moveBack() {
        guard currentIndex > 0 else { return }

        withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
            currentIndex -= 1
        }
    }

    private func loadNumberDraft() {
        guard case .number(let value) = answers[currentQuestion.id] else {
            numberText = ""
            return
        }

        if value.truncatingRemainder(dividingBy: 1) == 0 {
            numberText = String(Int(value))
        } else {
            numberText = String(value)
        }
    }

    private func returnToDiagnosisList() {
        shouldDismissFlowAfterResult = true
        result = nil
    }

    private func startTimerIfNeeded() {
        guard tracksElapsedTime, timerStartedAt == nil else { return }

        timerStartedAt = Date()
        elapsedSeconds = 0
    }
}

#Preview {
    NavigationStack {
        DiagnosisFlowView(diagnosis: DiagnosisCatalog.diagnoses[0])
            .environmentObject(HistoryStore())
    }
}
