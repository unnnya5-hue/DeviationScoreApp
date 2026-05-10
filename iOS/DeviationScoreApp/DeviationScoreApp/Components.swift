import SwiftUI

struct AppBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.96, green: 0.98, blue: 1.00),
                        Color(red: 1.00, green: 0.97, blue: 0.94)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}

extension View {
    func appBackground() -> some View {
        modifier(AppBackground())
    }
}

struct DiagnosisCard: View {
    let diagnosis: Diagnosis

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: diagnosis.category.symbolName)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(diagnosis.category.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(diagnosis.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                    Text("\(diagnosis.questions.count)問")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text(diagnosis.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Text("約\(diagnosis.estimatedMinutes)分")
                    .font(.caption)
                    .foregroundStyle(diagnosis.category.accentColor)
            }
        }
        .padding(14)
        .background(.white.opacity(0.86))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct ScoreBadge: View {
    let score: Int
    let color: Color

    var body: some View {
        VStack(spacing: 2) {
            Text("偏差値")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("\(score)")
                .font(.system(size: 64, weight: .black, design: .rounded))
                .foregroundStyle(color)
                .contentTransition(.numericText())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

