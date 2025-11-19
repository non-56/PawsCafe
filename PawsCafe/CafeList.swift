import Foundation
import SwiftUI
import MapKit

// MARK: - モデル定義 (Codable対応)

/// 予定モデル（Date対応＋メモ追加）
struct CafePlan: Identifiable, Codable {
    let id: UUID
    let date: Date
    let name: String
    let memo: String?
}

// MARK: - UserDefaults データ管理クラス

class CafeDataManager {
    static let shared = CafeDataManager()
    private let userDefaults = UserDefaults.standard
    
    private let cafeListKey = "cafeListKey"

    func saveCafes(_ cafes: [Cafe]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(cafes)
            userDefaults.set(data, forKey: cafeListKey)
            print("カフェリストの保存に成功しました。")
        } catch {
            print("カフェリストの保存に失敗しました: \(error)")
        }
    }

    func loadCafes() -> [Cafe] {
        let decoder = JSONDecoder()
        if let data = userDefaults.data(forKey: cafeListKey) {
            do {
                let cafes = try decoder.decode([Cafe].self, from: data)
                print("カフェリストの読み込みに成功しました。")
                return cafes
            } catch {
                print("カフェリストの読み込みに失敗しました: \(error)")
            }
        }
        return []
    }
}

// MARK: - ViewModel

class CafeViewModel: ObservableObject {
    @Published var allCafes: [Cafe] = []
    @Published var cafePlans: [CafePlan] = []
    @Published var favoriteCafes: [Cafe] = []
    @Published var recommendCafes: [Cafe] = []

    init() {
        loadSampleData()
    }

    func loadSampleData() {
        // 日付フォーマッタ
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"

        // カフェ一覧
        self.allCafes = Cafe.sample
        
        // 予定
        self.cafePlans = []

        self.recommendCafes = Array(self.allCafes.shuffled().prefix(2))
    }
}

extension CafeViewModel {
    func toggleFavorite(cafe: Cafe) {
        if let index = favoriteCafes.firstIndex(of: cafe) {
            favoriteCafes.remove(at: index)
        } else {
            favoriteCafes.append(cafe)
        }
    }
    
    func isFavorite(cafe: Cafe) -> Bool {
        favoriteCafes.contains(cafe)
    }
}
