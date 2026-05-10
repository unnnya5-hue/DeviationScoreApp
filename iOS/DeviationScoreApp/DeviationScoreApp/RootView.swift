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
    }
}

private struct HomeView: View {
    private let featured = DiagnosisCatalog.diagnoses[0]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("偏差値メーカー")
                        .font(.largeTitle.bold())
                    Text("いろんな自分を、だいたい偏差値で遊ぶ。")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text("結果はエンタメ用の簡易診断です。気軽に笑って、スクショして、また遊べます。")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 8)

                NavigationLink {
                    DiagnosisFlowView(diagnosis: featured)
                } label: {
                    DiagnosisCard(diagnosis: featured)
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 10) {
                    Text("すぐ遊べる診断")
                        .font(.title3.bold())

                    ForEach(DiagnosisCatalog.diagnoses) { diagnosis in
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
        List {
            ForEach(DiagnosisCategory.allCases) { category in
                Section(category.rawValue) {
                    ForEach(DiagnosisCatalog.diagnoses.filter { $0.category == category }) { diagnosis in
                        NavigationLink {
                            DiagnosisFlowView(diagnosis: diagnosis)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: diagnosis.category.symbolName)
                                    .foregroundStyle(diagnosis.category.accentColor)
                                    .frame(width: 28)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(diagnosis.title)
                                    Text(diagnosis.summary)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("偏差値一覧")
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
                LabeledContent("初期版", value: "MVP 0.1")
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

