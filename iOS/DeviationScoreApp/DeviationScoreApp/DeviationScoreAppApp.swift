import SwiftUI

@main
struct DeviationScoreAppApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var historyStore = HistoryStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(historyStore)
                .onAppear {
                    AppOpenAdManager.shared.showOnAppLaunchIfPossible()
                    InterstitialAdManager.shared.prepareAd()
                }
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active {
                        AppOpenAdManager.shared.showOnForegroundIfAvailable()
                    }
                }
        }
    }
}
