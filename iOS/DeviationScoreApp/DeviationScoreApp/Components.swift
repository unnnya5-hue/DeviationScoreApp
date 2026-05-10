import SwiftUI

struct AppBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                ZStack {
                    LinearGradient(
                        colors: [
                            Color(red: 1.00, green: 0.97, blue: 0.82),
                            Color(red: 0.86, green: 0.98, blue: 1.00),
                            Color(red: 1.00, green: 0.90, blue: 0.96)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    SymbolPattern()
                }
                .ignoresSafeArea()
            }
    }
}

extension View {
    func appBackground() -> some View {
        modifier(AppBackground())
    }
}

private struct SymbolPattern: View {
    private let symbols = [
        "sparkles",
        "number",
        "plus.forwardslash.minus",
        "bolt.fill",
        "dice.fill",
        "chart.bar.fill",
        "flame.fill",
        "questionmark",
        "target",
        "seal.fill"
    ]

    var body: some View {
        GeometryReader { proxy in
            ForEach(symbols.indices, id: \.self) { index in
                Image(systemName: symbols[index])
                    .font(.system(size: CGFloat(18 + (index % 4) * 7), weight: .black))
                    .foregroundStyle(.white.opacity(0.35))
                    .rotationEffect(.degrees(Double(index * 17)))
                    .position(
                        x: proxy.size.width * CGFloat((index * 29 + 13) % 100) / 100,
                        y: proxy.size.height * CGFloat((index * 41 + 9) % 100) / 100
                    )
            }
        }
        .allowsHitTesting(false)
    }
}

struct GameBadge: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.caption.bold())
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(.white.opacity(0.86))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct DiagnosisCard: View {
    let diagnosis: Diagnosis

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(diagnosis.category.accentColor)
                Image(systemName: diagnosis.category.symbolName)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
            }
            .frame(width: 54, height: 54)

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(diagnosis.title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(diagnosis.category.rawValue)
                            .font(.caption.bold())
                            .foregroundStyle(diagnosis.category.accentColor)
                    }

                    Spacer()

                    Image(systemName: "chevron.right.circle.fill")
                        .font(.title3)
                        .foregroundStyle(diagnosis.category.accentColor)
                }

                Text(diagnosis.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                HStack(spacing: 6) {
                    GameBadge(text: "\(diagnosis.questions.count)問", color: diagnosis.category.accentColor)
                    GameBadge(text: "約\(diagnosis.estimatedMinutes)分", color: diagnosis.category.accentColor)
                    if diagnosis.hasNumberQuestions {
                        GameBadge(text: "数字入力あり", color: diagnosis.category.accentColor)
                    }
                }
            }
        }
        .padding(14)
        .background {
            LinearGradient(
                colors: [
                    diagnosis.category.softColor.opacity(0.96),
                    .white.opacity(0.94)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(diagnosis.category.accentColor.opacity(0.18), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: diagnosis.category.accentColor.opacity(0.14), radius: 14, y: 8)
    }
}

struct ScoreBadge: View {
    let score: Int
    let color: Color

    private var progress: Double {
        min(max((Double(score) - 20) / 60, 0), 1)
    }

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Text("偏差値メーター")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                Spacer()
                Text("20-80")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
            }

            Text("\(score)")
                .font(.system(size: 72, weight: .black, design: .rounded))
                .foregroundStyle(color)
                .contentTransition(.numericText())

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.08))
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                        .frame(width: max(12, proxy.size.width * progress))
                }
            }
            .frame(height: 14)
        }
        .frame(maxWidth: .infinity)
        .padding(18)
        .background(.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: color.opacity(0.14), radius: 14, y: 8)
    }
}
