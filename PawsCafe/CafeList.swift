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

// MARK: - カフェモデル

struct Cafe: Identifiable, Equatable, Codable {
    let id: UUID
    let name: String
    let animals: [String]
    let address: String
    let call: String
    let price: String
    let url: URL
    let imageName: String
    
    let latitude: Double
    let longitude: Double
    let tags: [String]?
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
            print("✅ カフェリストの保存に成功しました。")
        } catch {
            print("❌ カフェリストの保存に失敗しました: \(error)")
        }
    }

    func loadCafes() -> [Cafe] {
        let decoder = JSONDecoder()
        if let data = userDefaults.data(forKey: cafeListKey) {
            do {
                let cafes = try decoder.decode([Cafe].self, from: data)
                print("✅ カフェリストの読み込みに成功しました。")
                return cafes
            } catch {
                print("❌ カフェリストの読み込みに失敗しました: \(error)")
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
        self.allCafes = [
            Cafe(id: UUID(), name: "にゃんにゃんカフェ", animals:["ネコ"], address:"大阪府", call:"080-XXXX-XXXX", price:"1001円〜2000円", url: URL(string: "https://umeda.example.com")!, imageName: "cafe1", latitude: 34.7025, longitude: 135.4959, tags: ["12歳以下OK","女性のみ"]),
            Cafe(id: UUID(), name: "わんわんカフェ", animals:["イヌ"], address:"大阪府", call:"080-XXXX-XXXX", price:"2001円〜3000円", url: URL(string: "https://shinsaibashi.example.com")!, imageName: "cafe2", latitude: 34.6723, longitude: 135.5033, tags: []),
            Cafe(id: UUID(), name: "ぴよぴよカフェ", animals:["鳥類"], address:"大阪府", call:"080-XXXX-XXXX", price:"2001円〜3000円", url: URL(string: "https://tennoji.example.com")!, imageName: "cafe3", latitude: 34.6469, longitude: 135.5132, tags: []),
            Cafe(id: UUID(), name: "ぶーぶーカフェ", animals:["ブタ"], address:"大阪府", call:"080-XXXX-XXXX", price:"2001円〜3000円", url: URL(string: "https://horie.example.com")!, imageName: "cafe4", latitude: 34.6749, longitude: 135.4949, tags: [])
        ]
        
        // 予定
        self.cafePlans = [
            CafePlan(id: UUID(), date: formatter.date(from: "2025年9月13日")!, name: "にゃんにゃんカフェ", memo: "猫たちとリラックス"),
            CafePlan(id: UUID(), date: formatter.date(from: "2025年9月15日")!, name: "わんわんカフェ", memo: "新しい犬カフェを試す"),
            CafePlan(id: UUID(), date: formatter.date(from: "2025年9月20日")!, name: "ぴよぴよカフェ", memo: nil),
            CafePlan(id: UUID(), date: formatter.date(from: "2025年9月25日")!, name: "ぶーぶーカフェ", memo: "友達と一緒に")
        ]

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
