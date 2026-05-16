import GoogleMobileAds
import SwiftUI

@MainActor
final class AppOpenAdManager: NSObject, FullScreenContentDelegate {
    static let shared = AppOpenAdManager()

    private var appOpenAd: AppOpenAd?
    private var isLoadingAd = false
    private var isShowingAd = false
    private var loadTime: Date?
    private var shouldShowAfterLoad = false
    private var didRequestLaunchAd = false
    private let timeoutInterval: TimeInterval = 4 * 3_600

    func showOnAppLaunchIfPossible() {
        guard !didRequestLaunchAd else { return }

        didRequestLaunchAd = true
        shouldShowAfterLoad = true
        Task {
            await loadAd()
        }
    }

    func showOnForegroundIfAvailable() {
        guard didRequestLaunchAd else { return }

        if isAdAvailable {
            presentAdIfAvailable(cooldown: 30)
        } else {
            Task {
                await loadAd()
            }
        }
    }

    func loadAd() async {
        guard AdMobConfiguration.hasApplicationID else { return }
        guard !isLoadingAd, !isAdAvailable else {
            if shouldShowAfterLoad {
                shouldShowAfterLoad = false
                presentAdIfAvailable(cooldown: 0)
            }
            return
        }

        AdMobConfiguration.startSDKIfNeeded()
        isLoadingAd = true

        do {
            appOpenAd = try await AppOpenAd.load(
                with: AdMobConfiguration.appOpenAdUnitID,
                request: Request()
            )
            appOpenAd?.fullScreenContentDelegate = self
            loadTime = Date()

            if shouldShowAfterLoad {
                shouldShowAfterLoad = false
                presentAdIfAvailable(cooldown: 0)
            }
        } catch {
            #if DEBUG
            print("App open ad failed: \(error.localizedDescription)")
            #endif
            appOpenAd = nil
            loadTime = nil
            shouldShowAfterLoad = false
        }

        isLoadingAd = false
    }

    func ad(
        _ ad: FullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        #if DEBUG
        print("App open ad failed to present: \(error.localizedDescription)")
        #endif
        clearPresentedAd()
        Task {
            await loadAd()
        }
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        clearPresentedAd()
        Task {
            await loadAd()
        }
    }

    private var isAdAvailable: Bool {
        guard appOpenAd != nil, let loadTime else { return false }

        return Date().timeIntervalSince(loadTime) < timeoutInterval
    }

    private func presentAdIfAvailable(cooldown: TimeInterval) {
        guard !isShowingAd,
              let appOpenAd,
              AdMobConfiguration.canPresentFullScreenAd(cooldown: cooldown)
        else { return }

        isShowingAd = true
        AdMobConfiguration.markFullScreenAdPresented()
        appOpenAd.present(from: nil)
    }

    private func clearPresentedAd() {
        appOpenAd = nil
        loadTime = nil
        isShowingAd = false
        AdMobConfiguration.markFullScreenAdFinished()
    }
}

@MainActor
final class InterstitialAdManager: NSObject, FullScreenContentDelegate {
    static let shared = InterstitialAdManager()

    private var interstitialAd: InterstitialAd?
    private var isLoadingAd = false
    private var isShowingAd = false
    private var loadTime: Date?
    private let timeoutInterval: TimeInterval = 3_600

    func prepareAd() {
        Task {
            await loadAd()
        }
    }

    func showAfterDiagnosisCompletion() {
        guard isAdAvailable else {
            prepareAd()
            return
        }

        presentAdIfAvailable()
    }

    func loadAd() async {
        guard AdMobConfiguration.hasApplicationID else { return }
        guard !isLoadingAd, !isAdAvailable else { return }

        AdMobConfiguration.startSDKIfNeeded()
        isLoadingAd = true

        do {
            interstitialAd = try await InterstitialAd.load(
                with: AdMobConfiguration.interstitialAdUnitID,
                request: Request()
            )
            interstitialAd?.fullScreenContentDelegate = self
            loadTime = Date()
        } catch {
            #if DEBUG
            print("Interstitial ad failed: \(error.localizedDescription)")
            #endif
            interstitialAd = nil
            loadTime = nil
        }

        isLoadingAd = false
    }

    func ad(
        _ ad: FullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        #if DEBUG
        print("Interstitial ad failed to present: \(error.localizedDescription)")
        #endif
        clearPresentedAd()
        prepareAd()
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        clearPresentedAd()
        prepareAd()
    }

    private var isAdAvailable: Bool {
        guard interstitialAd != nil, let loadTime else { return false }

        return Date().timeIntervalSince(loadTime) < timeoutInterval
    }

    private func presentAdIfAvailable() {
        guard !isShowingAd,
              let interstitialAd,
              AdMobConfiguration.canPresentFullScreenAd(cooldown: 8)
        else { return }

        isShowingAd = true
        AdMobConfiguration.markFullScreenAdPresented()
        interstitialAd.present(from: nil)
    }

    private func clearPresentedAd() {
        interstitialAd = nil
        loadTime = nil
        isShowingAd = false
        AdMobConfiguration.markFullScreenAdFinished()
    }
}
