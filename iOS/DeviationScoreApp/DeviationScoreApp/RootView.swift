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
                        Text("いろいろ偏差値診断")
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

                AdBannerSlot(placement: "home-featured")

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

private enum DiagnosisFilter: Hashable {
    case all
    case new
    case category(DiagnosisCategory)
}

private struct DiagnosisListView: View {
    @State private var filter: DiagnosisFilter = .all
    @State private var searchText = ""

    private var filteredDiagnoses: [Diagnosis] {
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        return DiagnosisCatalog.diagnoses.filter { diagnosis in
            let matchesFilter: Bool
            switch filter {
            case .all:
                matchesFilter = true
            case .new:
                matchesFilter = DiagnosisCatalog.isNew(diagnosis)
            case .category(let category):
                matchesFilter = diagnosis.category == category
            }

            guard matchesFilter else { return false }
            guard !keyword.isEmpty else { return true }

            return [diagnosis.title, diagnosis.shortTitle, diagnosis.summary, diagnosis.category.rawValue]
                .contains { $0.localizedCaseInsensitiveContains(keyword) }
        }
    }

    private var availableCategories: [DiagnosisCategory] {
        DiagnosisCategory.allCases.filter { category in
            DiagnosisCatalog.diagnoses.contains { $0.category == category }
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                filterChips

                let results = filteredDiagnoses

                if results.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                }

                ForEach(DiagnosisCategory.allCases) { category in
                    let diagnoses = results.filter { $0.category == category }

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

                AdBannerSlot(placement: "diagnosis-list-bottom")
            }
            .padding()
        }
        .navigationTitle("偏差値一覧")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "診断名・キーワードで検索")
        .appBackground()
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "すべて", systemImage: "square.grid.2x2", color: .pink, isSelected: filter == .all) {
                    filter = .all
                }

                if !DiagnosisCatalog.newDiagnosisIDs.isEmpty {
                    FilterChip(title: "NEW", systemImage: "sparkles", color: .orange, isSelected: filter == .new) {
                        filter = .new
                    }
                }

                ForEach(availableCategories) { category in
                    FilterChip(
                        title: category.rawValue,
                        systemImage: category.symbolName,
                        color: category.accentColor,
                        isSelected: filter == .category(category)
                    ) {
                        filter = .category(category)
                    }
                }
            }
            .padding(.vertical, 2)
        }
    }
}

private struct FilterChip: View {
    let title: String
    let systemImage: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.bold())
                .foregroundStyle(isSelected ? .white : color)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? color : .white.opacity(0.9))
                .clipShape(Capsule())
                .overlay {
                    Capsule().stroke(color.opacity(0.35), lineWidth: 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
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
                    NavigationLink {
                        HistoryResultDetailView(result: result)
                    } label: {
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
                            Text(result.measuredAt, format: .dateTime.month().day().hour().minute())
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }

                AdBannerSlot(placement: "history-bottom")
                    .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                    .listRowBackground(Color.clear)
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

private struct HistoryResultDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let result: DiagnosisResult

    var body: some View {
        ResultView(
            result: result,
            closeButtonTitle: "履歴へ戻る",
            closeButtonIcon: "chevron.left",
            hidesBackButton: false
        ) {
            dismiss()
        }
    }
}

private struct SettingsView: View {
    var body: some View {
        List {
            Section("このアプリについて") {
                LabeledContent("用途", value: "エンタメ診断")
                LabeledContent("バージョン", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-")
                LabeledContent("診断数", value: "\(DiagnosisCatalog.diagnoses.count)")
            }

            Section("注意") {
                Text("表示される偏差値は、医療・心理・学力・結婚可能性などを正確に評価するものではありません。")
                    .foregroundStyle(.secondary)
            }

            Section {
                AdBannerSlot(placement: "settings-bottom")
                    .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                    .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("設定")
    }
}

#Preview {
    RootView()
        .environmentObject(HistoryStore())
}
