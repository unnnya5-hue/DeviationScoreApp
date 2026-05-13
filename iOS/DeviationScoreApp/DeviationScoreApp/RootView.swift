import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("トップ", systemImage: "sparkles")
            }

            NavigationStack {
                DiagnosisListView()
            }
            .tabItem {
                Label("診断", systemImage: "list.bullet.rectangle")
            }

            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Label("履歴", systemImage: "clock.arrow.circlepath")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("設定", systemImage: "gearshape")
            }
        }
        .tint(Color(red: 0.95, green: 0.22, blue: 0.48))
    }
}

private struct HomeView: View {
    private let featured = DiagnosisCatalog.diagnoses[0]
    private var questionRangeText: String {
        let counts = DiagnosisCatalog.diagnoses.map(\.questions.count)
        let minimum = counts.min() ?? 0
        let maximum = counts.max() ?? minimum

        if minimum == maximum {
            return "各\(minimum)問"
        }

        return "\(minimum)〜\(maximum)問"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.title.bold())
                            .foregroundStyle(.yellow)
                        Text("偏差値あそび")
                            .font(.largeTitle.bold())
                    }

                    Text("気になるテーマを選んで、あなたの偏差値をゆるく診断。")
                        .font(.title3.bold())
                    Text("結果はエンタメ目的の簡易スコアです。友だちとの話題やSNSのネタとして楽しめます。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 8)

                HStack(spacing: 8) {
                    GameBadge(text: "\(DiagnosisCatalog.diagnoses.count)診断", color: .pink)
                    GameBadge(text: questionRangeText, color: .teal)
                    GameBadge(text: "数字入力あり", color: .purple)
                }

                NavigationLink {
                    DiagnosisFlowView(diagnosis: featured)
                } label: {
                    DiagnosisCard(diagnosis: featured)
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 10) {
                    Text("ゲームモード")
                        .font(.title3.bold())

                    ForEach(Array(DiagnosisCatalog.diagnoses.dropFirst())) { diagnosis in
                        NavigationLink {
                            DiagnosisFlowView(diagnosis: diagnosis)
                        } label: {
                            DiagnosisCard(diagnosis: diagnosis)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("トップ")
        .appBackground()
    }
}

private struct DiagnosisListView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ForEach(DiagnosisCategory.allCases) { category in
                    let diagnoses = DiagnosisCatalog.diagnoses.filter { $0.category == category }

                    if !diagnoses.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: category.symbolName)
                                    .foregroundStyle(category.accentColor)
                                Text(category.rawValue)
                                    .font(.headline)
                                Spacer()
                            }

                            ForEach(diagnoses) { diagnosis in
                                NavigationLink {
                                    DiagnosisFlowView(diagnosis: diagnosis)
                                } label: {
                                    DiagnosisCard(diagnosis: diagnosis)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("偏差値一覧")
        .appBackground()
    }
}

private struct HistoryView: View {
    @EnvironmentObject private var historyStore: HistoryStore

    var body: some View {
        List {
            if historyStore.results.isEmpty {
                ContentUnavailableView(
                    "履歴はまだありません",
                    systemImage: "clock",
                    description: Text("診断すると結果がここに残ります。")
                )
            } else {
                ForEach(historyStore.results) { result in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(result.diagnosisTitle)
                                .font(.headline)
                            Spacer()
                            Text("偏差値\(result.deviationScore)")
                                .font(.headline)
                                .foregroundStyle(result.category.accentColor)
                        }
                        Text(result.rankTitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(result.measuredAt, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("診断履歴")
        .toolbar {
            if !historyStore.results.isEmpty {
                Button("削除", role: .destructive) {
                    historyStore.clear()
                }
            }
        }
    }
}

private struct SettingsView: View {
    var body: some View {
        List {
            Section("このアプリについて") {
                LabeledContent("用途", value: "エンタメ診断")
                LabeledContent("バージョン", value: "MVP 0.2")
                LabeledContent("診断数", value: "\(DiagnosisCatalog.diagnoses.count)")
            }

            Section("注意") {
                Text("表示される偏差値は、医療・心理・学力・結婚可能性などを正確に評価するものではありません。")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("設定")
    }
}

#Preview {
    RootView()
        .environmentObject(HistoryStore())
}
