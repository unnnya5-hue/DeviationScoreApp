import SwiftUI

@main
struct DeviationScoreAppApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var historyStore = HistoryStore()
    @State private var didStartAds = false

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(historyStore)
                .preferredColorScheme(.light)
                .onChange(of: scenePhase, initial: true) { _, newPhase in
                    guard newPhase == .active else { return }
                    Task { await startAdsAfterConsent() }
                }
        }
    }

    /// 初回は同意確認（UMP → ATT）を済ませてから広告を始める。2回目以降のアクティブ化ではアプリ起動広告を出す。
    @MainActor
    private func startAdsAfterConsent() async {
        if didStartAds {
            AppOpenAdManager.shared.showOnForegroundIfAvailable()
            return
        }

        await AdConsentManager.shared.gatherConsentIfNeeded()
        guard !didStartAds else { return }
        didStartAds = true
        AppOpenAdManager.shared.showOnAppLaunchIfPossible()
        InterstitialAdManager.shared.prepareAd()
    }
}
