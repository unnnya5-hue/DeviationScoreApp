import SwiftUI

@main
struct DeviationScoreAppApp: App {
    @StateObject private var historyStore = HistoryStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(historyStore)
        }
    }
}
