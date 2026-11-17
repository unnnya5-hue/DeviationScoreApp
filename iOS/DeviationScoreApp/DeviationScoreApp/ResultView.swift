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

                VStack(alignment: .leading, spacing: 8) {
                    Label("ワンポイント", systemImage: "lightbulb.fill")
                        .font(.caption.bold())
                        .foregroundStyle(result.category.accentColor)
                    Text(result.category.onePointAdvice(for: result.deviationScore))
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(.white.opacity(0.92))
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Text("※結果はエンタメ目的の簡易スコアです。医学的・心理学的な診断や能力評価ではありません。")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

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

extension DiagnosisCategory {
    /// カテゴリと偏差値の帯（45未満 / 58未満 / 58以上）で出し分ける結果画面のひとこと。
    func onePointAdvice(for score: Int) -> String {
        let tier = score < 45 ? 0 : (score < 58 ? 1 : 2)
        return onePointAdvices[tier]
    }

    private var onePointAdvices: [String] {
        switch self {
        case .romance:
            return [
                "まずは相手の話を最後まで聞くことから。聞き上手はそれだけで好印象です。",
                "基本はできています。次は「相手が喜ぶ一言」を1つ増やしてみましょう。",
                "気配り上手です。がんばりすぎて疲れないよう、自分のペースも大事に。"
            ]
        case .knowledge:
            return [
                "解説を読むだけでも点数は上がります。気になった問題を1つ調べてみましょう。",
                "あと数問で上位です。ひっかけ問題は、問題文をもう一度読むのがコツ。",
                "知識もひらめきも十分です。友達に問題を出して、どこまで解けるか試してみては？"
            ]
        case .social:
            return [
                "完璧な会話より、あいさつと相づちから。小さな積み重ねが効いてきます。",
                "場に合わせる力があります。次は自分から話題を1つ出してみましょう。",
                "周りをよく見ています。たまには聞き役を休んで、自分の話もしてOKです。"
            ]
        case .career:
            return [
                "まずは「早めの報告」だけ意識してみましょう。それだけで信頼度が変わります。",
                "仕事の基本は押さえています。次は段取りを先に決める習慣を。",
                "頼れる社会人です。抱え込みすぎず、周りに任せる勇気も持ちましょう。"
            ]
        case .jobHunt:
            return [
                "準備の量がそのまま自信になります。想定質問を3つだけ書き出してみましょう。",
                "土台はできています。経験談を具体的な数字やエピソードで話せると強いです。",
                "準備は万全です。本番では、うまく話すより自分の言葉で話すことを大切に。"
            ]
        case .money:
            return [
                "まずは1か月、何に使ったかを見える化するところから始めましょう。",
                "お金の感覚は悪くありません。固定費を1つ見直すと効果が大きいです。",
                "お金の管理が上手です。使うべきところで使う楽しさも忘れずに。"
            ]
        case .life:
            return [
                "全部やろうとしなくて大丈夫。今日は1つだけ片付けてみましょう。",
                "生活の回し方は安定しています。週1の「まとめてやる日」を作るとさらに楽に。",
                "生活力が高いです。そのノウハウ、周りの人にも教えてあげてください。"
            ]
        case .mental:
            return [
                "しんどいときは休むのも立派な選択です。つらさが続くときは信頼できる人や専門家に相談を。",
                "うまく付き合えています。自分に合う回復方法を1つ増やしておくと安心です。",
                "心のバランスが取れています。周りに疲れている人がいたら、そっと声をかけてみて。"
            ]
        case .style:
            return [
                "清潔感を整えるだけで印象は大きく変わります。まずは髪と爪から。",
                "センスは十分です。自分に似合う色や形を1つ決めると、さらに垢抜けます。",
                "おしゃれ上級者です。流行よりも「自分らしさ」を大切にしていきましょう。"
            ]
        case .hobby:
            return [
                "楽しんだ者勝ちです。点数より「好き」の気持ちを大事にしてください。",
                "しっかり楽しめています。同じ趣味の仲間を見つけると、もっと深まります。",
                "立派なガチ勢です。その熱量をSNSで発信すると、仲間が集まってきそうです。"
            ]
        case .fun:
            return [
                "この結果もネタとして楽しんだ者勝ちです。友達の結果と比べてみましょう。",
                "ちょうどいいバランスです。シェアすると「わかる」と言われそうな結果です。",
                "突き抜けています。この結果はぜひスクショして話のネタにしてください。"
            ]
        }
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
