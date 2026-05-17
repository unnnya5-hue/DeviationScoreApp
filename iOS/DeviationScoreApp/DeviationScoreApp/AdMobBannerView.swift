import GoogleMobileAds
import SwiftUI

enum AdMobConfiguration {
    static let isUsingTestAds = false
    static let bannerAdUnitID = "ca-app-pub-6961277874965643/3783944323"
    static let appOpenAdUnitID = "ca-app-pub-6961277874965643/4022634932"
    static let interstitialAdUnitID = "ca-app-pub-6961277874965643/2453568249"

    private static var didStartSDK = false
    private static var isPresentingFullScreenAd = false
    private static var lastFullScreenAdDismissedAt: Date?

    static var hasApplicationID: Bool {
        guard let appID = Bundle.main.object(forInfoDictionaryKey: "GADApplicationIdentifier") as? String else {
            return false
        }

        return !appID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    static func startSDKIfNeeded() {
        guard hasApplicationID, !didStartSDK else { return }

        didStartSDK = true
        MobileAds.shared.start()
    }

    static func canPresentFullScreenAd(cooldown: TimeInterval) -> Bool {
        guard !isPresentingFullScreenAd else { return false }

        if let lastFullScreenAdDismissedAt {
            return Date().timeIntervalSince(lastFullScreenAdDismissedAt) >= cooldown
        }

        return true
    }

    static func markFullScreenAdPresented() {
        isPresentingFullScreenAd = true
    }

    static func markFullScreenAdFinished() {
        isPresentingFullScreenAd = false
        lastFullScreenAdDismissedAt = Date()
    }
}

struct AdBannerSlot: View {
    let placement: String

    @State private var availableWidth: CGFloat = 0

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("広告")
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)

                Spacer()

                if AdMobConfiguration.isUsingTestAds {
                    Text("TEST")
                        .font(.caption2.bold())
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 2)

            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        updateWidth(proxy.size.width)
                    }
                    .onChange(of: proxy.size.width) { _, newWidth in
                        updateWidth(newWidth)
                    }
            }
            .frame(height: 0)

            if isRunningForPreview {
                previewBanner
            } else if !AdMobConfiguration.hasApplicationID {
                missingConfigurationBanner
            } else if availableWidth > 0 {
                banner(for: availableWidth)
            }
        }
        .padding(10)
        .background(.white.opacity(0.86))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .accessibilityIdentifier("ad-banner-\(placement)")
    }

    private var isRunningForPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

    private var previewBanner: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.16))
            .frame(height: 64)
            .overlay {
                Text("AdMob Banner")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
            }
    }

    private var missingConfigurationBanner: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.12))
            .frame(height: 56)
            .overlay {
                #if DEBUG
                Text("AdMob App ID is missing")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                #endif
            }
    }

    private func banner(for width: CGFloat) -> some View {
        let adSize = largeAnchoredAdaptiveBanner(width: max(width, 320))

        return BannerViewContainer(
            adSize: adSize,
            adUnitID: AdMobConfiguration.bannerAdUnitID
        )
        .frame(width: adSize.size.width, height: adSize.size.height)
        .frame(maxWidth: .infinity)
    }

    private func updateWidth(_ width: CGFloat) {
        guard width > 0, abs(width - availableWidth) > 1 else { return }

        availableWidth = width
    }
}

private struct BannerViewContainer: UIViewRepresentable {
    let adSize: AdSize
    let adUnitID: String

    func makeUIView(context: Context) -> BannerView {
        AdMobConfiguration.startSDKIfNeeded()

        let banner = BannerView(adSize: adSize)
        banner.adUnitID = adUnitID
        banner.delegate = context.coordinator
        banner.load(Request())
        return banner
    }

    func updateUIView(_ banner: BannerView, context: Context) {
        if banner.adSize.size != adSize.size {
            banner.adSize = adSize
            banner.load(Request())
        }
    }

    func makeCoordinator() -> BannerCoordinator {
        BannerCoordinator()
    }
}

private final class BannerCoordinator: NSObject, BannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        #if DEBUG
        print("AdMob banner loaded.")
        #endif
    }

    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        #if DEBUG
        print("AdMob banner failed: \(error.localizedDescription)")
        #endif
    }
}
