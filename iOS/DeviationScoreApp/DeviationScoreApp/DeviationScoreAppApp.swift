import GoogleMobileAds
import SwiftUI

@main
struct DeviationScoreAppApp: App {
    @StateObject private var historyStore = HistoryStore()

    init() {
        MobileAds.shared.start()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(historyStore)
        }
    }
}
