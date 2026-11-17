import AppTrackingTransparency
import GoogleMobileAds
import SwiftUI
import UserMessagingPlatform

/// 広告の同意まわり（UMP の同意フォーム → ATT のトラッキング許可）をまとめて扱う。
///
/// 流れ:
/// 1. 起動してアプリがアクティブになったら UMP の同意情報を更新し、必要なら同意フォームを出す
///    （EEA・英国など同意が必要な地域の利用者だけに表示される）
/// 2. ATT のトラッキング許可ダイアログを出す（未確認の場合のみ。AdMob 側で IDFA 説明メッセージを設定していれば UMP が先に出す）
/// 3. 広告をリクエストしてよい状態（canRequestAds）になってから SDK を起動して広告を読み込む
@MainActor
final class AdConsentManager: ObservableObject {
    static let shared = AdConsentManager()

    /// 広告をリクエストしてよいか。true になるまで広告SDKを起動しない。
    @Published private(set) var canRequestAds = false
    /// 設定画面に「広告のプライバシー設定」を出す必要があるか（同意が必要な地域の利用者のみ true）。
    @Published private(set) var isPrivacyOptionsRequired = false
    @Published private(set) var trackingStatus: ATTrackingManager.AuthorizationStatus = ATTrackingManager.trackingAuthorizationStatus

    /// UIテスト中は同意確認も止める。ただし起動引数 -testConsentFlow があれば同意確認だけ実行する（広告は読み込まない）。
    private static var isConsentFlowDisabled: Bool {
        #if DEBUG
        return AdMobConfiguration.isDisabledForUITesting
            && !ProcessInfo.processInfo.arguments.contains("-testConsentFlow")
        #else
        return false
        #endif
    }

    private var isGathering = false
    private var didGather = false

    private init() {
        // 前回起動時に同意済みなら、今回の確認を待たずに広告を始められる
        canRequestAds = !AdMobConfiguration.isDisabledForUITesting && ConsentInformation.shared.canRequestAds
    }

    /// 起動時に1回だけ実行する。アプリがアクティブ（scenePhase == .active）になってから呼ぶこと。
    /// ATT のダイアログはアクティブでないと表示されないため。
    func gatherConsentIfNeeded() async {
        guard !Self.isConsentFlowDisabled, !didGather, !isGathering else { return }
        isGathering = true
        defer {
            isGathering = false
            didGather = true
        }

        do {
            try await ConsentInformation.shared.requestConsentInfoUpdate(with: Self.makeRequestParameters())
            try await ConsentForm.loadAndPresentIfRequired(from: nil)
        } catch {
            // 通信エラーなどでも、前回の同意状態が残っていれば canRequestAds で判断できる
            #if DEBUG
            print("UMP consent failed: \(error.localizedDescription)")
            #endif
        }

        await requestTrackingAuthorizationIfNeeded()
        refreshStatus()
    }

    /// 設定画面から同意内容を変更する。
    func presentPrivacyOptionsForm() async {
        do {
            try await ConsentForm.presentPrivacyOptionsForm(from: nil)
        } catch {
            #if DEBUG
            print("UMP privacy options failed: \(error.localizedDescription)")
            #endif
        }
        refreshStatus()
    }

    private func requestTrackingAuthorizationIfNeeded() async {
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else { return }

        _ = await ATTrackingManager.requestTrackingAuthorization()
    }

    private func refreshStatus() {
        canRequestAds = AdMobConfiguration.canRequestAds
        isPrivacyOptionsRequired = ConsentInformation.shared.privacyOptionsRequirementStatus == .required
        trackingStatus = ATTrackingManager.trackingAuthorizationStatus
    }

    private static func makeRequestParameters() -> RequestParameters {
        let parameters = RequestParameters()
        #if DEBUG
        // 動作確認用: 起動引数 -umpDebugGeographyEEA で、日本からでもEEAの同意フォームを表示する（シミュレータは自動でテスト端末扱い）
        if ProcessInfo.processInfo.arguments.contains("-umpDebugGeographyEEA") {
            let debugSettings = DebugSettings()
            debugSettings.geography = .EEA
            parameters.debugSettings = debugSettings
        }
        #endif
        return parameters
    }
}

/// 設定画面の「広告とプライバシー」欄。
struct AdPrivacySection: View {
    @ObservedObject private var consent = AdConsentManager.shared
    @Environment(\.openURL) private var openURL

    var body: some View {
        Section {
            LabeledContent("トラッキング", value: trackingStatusText)
                .accessibilityIdentifier("tracking-status")

            if consent.isPrivacyOptionsRequired {
                Button("広告の同意設定を変更") {
                    Task { await consent.presentPrivacyOptionsForm() }
                }
                .accessibilityIdentifier("privacy-options-button")
            }

            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                Button("iPhoneの設定でトラッキングを変更") {
                    openURL(settingsURL)
                }
                .accessibilityIdentifier("open-settings-button")
            }
        } header: {
            Text("広告とプライバシー")
        } footer: {
            Text("このアプリは広告（Google AdMob）で運営しています。トラッキングを許可しない場合も、アプリはすべて利用できます（表示される広告がパーソナライズされなくなります）。")
        }
    }

    private var trackingStatusText: String {
        switch consent.trackingStatus {
        case .authorized: return "許可"
        case .denied: return "許可しない"
        case .restricted: return "制限あり"
        case .notDetermined: return "未設定"
        @unknown default: return "不明"
        }
    }
}
