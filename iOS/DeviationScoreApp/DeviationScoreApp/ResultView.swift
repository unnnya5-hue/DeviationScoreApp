import SwiftUI

struct ResultView: View {
    let result: DiagnosisResult
    var closeButtonTitle = "別の診断へ"
    var closeButtonIcon = "arrow.uturn.left"
    var hidesBackButton = true
    let closeAction: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                VStack(spacing: 10) {
                    Text("RESULT CARD")
                        .font(.caption.bold())
                        .foregroundStyle(result.category.accentColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    Text(result.diagnosisTitle)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text(result.rankTitle)
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 12)

                ScoreBadge(score: result.deviationScore, color: result.category.accentColor)

                if let elapsedTimeText = result.elapsedTimeText {
                    HStack {
                        Label("クリアタイム", systemImage: "timer")
                            .font(.caption.bold())
                            .foregroundStyle(result.category.accentColor)
                        Spacer()
                        Text(elapsedTimeText)
                            .font(.title2.bold())
                            .monospacedDigit()
                            .foregroundStyle(result.category.accentColor)
                    }
                    .padding()
                    .background(.white.opacity(0.92))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                VStack(alignment: .leading, spacing: 8) {
                    Label("判定コメント", systemImage: "text.bubble.fill")
                        .font(.caption.bold())
                        .foregroundStyle(result.category.accentColor)
                    Text(result.comment)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(.white.opacity(0.92))
                .clipShape(RoundedRectangle(cornerRadius: 8))

                ShareLink(item: result.shareText) {
                    Label("結果をシェア", systemImage: "square.and.arrow.up")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .tint(result.category.accentColor)

                Button {
                    closeAction()
                } label: {
                    Label(closeButtonTitle, systemImage: closeButtonIcon)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.bordered)

                AdBannerSlot(placement: "result-bottom")
            }
            .padding()
        }
        .navigationTitle("結果")
        .navigationBarBackButtonHidden(hidesBackButton)
        .appBackground()
    }
}

#Preview {
    NavigationStack {
        ResultView(
            result: DiagnosisResult(
                id: UUID(),
                diagnosisID: "marriage",
                diagnosisTitle: "婚活偏差値",
                category: .romance,
                rawScore: 32,
                deviationScore: 68,
                rankTitle: "なかなか上位勢",
                comment: "周りから一目置かれる場面がありそう。得意分野として名乗ってもよさげです。",
                measuredAt: Date(),
                elapsedSeconds: nil
            ),
            closeAction: {}
        )
    }
}
