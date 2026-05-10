import Foundation
import Combine

final class HistoryStore: ObservableObject {
    @Published private(set) var results: [DiagnosisResult] = []

    private let storageKey = "diagnosisResults"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
        load()
    }

    func save(_ result: DiagnosisResult) {
        results.insert(result, at: 0)
        persist()
    }

    func clear() {
        results.removeAll()
        persist()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            results = []
            return
        }

        results = (try? decoder.decode([DiagnosisResult].self, from: data)) ?? []
    }

    private func persist() {
        guard let data = try? encoder.encode(results) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
