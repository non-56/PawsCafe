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
            Cafe(id: UUID(), name: "犬カフェsamo", animals:["イヌ"], address:"大阪府", call:"", price:"2001〜3000円", url: URL(string: "https://dogcafe-samo.com/")!, imageName: "cafe1", latitude: 34.7025, longitude: 135.4959, tags: ["12歳以下不可","おやつ可"]),
                        Cafe(id: UUID(), name: "PREFAM", animals:["イヌ"], address:"大阪府", call:"06-6964-8853", price:"2001円〜3000円", url: URL(string: "https://prefam.jp/")!, imageName: "cafe2", latitude: 34.6723, longitude: 135.5033, tags: ["12歳以下不可"]),
                        Cafe(id: UUID(), name: "猫カフェMOCHA", animals:["ネコ"], address:"大阪府", call:"", price:"1001〜2000円", url: URL(string: "https://catmocha.jp/")!, imageName: "cafe3", latitude: 34.6469, longitude: 135.5132, tags: ["6歳から入場可","おやつ可","抱っこ可"]),
                        Cafe(id: UUID(), name: "nekotto", animals:["ネコ"], address:"大阪府", call:"080-4567-0025", price:"1001円〜2000円", url: URL(string: "https://www.nekotto22.com/")!, imageName: "cafe4", latitude: 34.6749, longitude: 135.4949, tags: ["3歳から入場可"]),
                        Cafe(id: UUID(), name: "cat tail", animals:["ネコ"], address:"大阪府", call:"06-6213-2279", price:"1001〜2000円", url: URL(string: "https://cattail.jp/")!, imageName: "cafe5", latitude: 34.6469, longitude: 135.5132, tags: ["5年生未満不可","おやつ可","抱っこ可"]),
                        Cafe(id: UUID(), name: "mipig cafe 大阪店", animals:["ブタ"], address:"大阪府", call:"06-6213-6334", price:"1001〜2000円", url: URL(string: "https://mipig.cafe/locations/osaka/")!, imageName: "cafe6", latitude: 34.6469, longitude: 135.5132, tags: ["年齢制限無し","抱っこ不可"]),
                        
                        Cafe(id: UUID(), name: "いぬカフェRio 京都店", animals:["ネコ","その他"], address:"京都府", call:"075-366-4281", price:"1001〜2000円", url: URL(string: "https://rio-corp.jp/shops/kyoto/")!, imageName: "cafe7", latitude: 34.6469, longitude: 135.5132, tags: ["抱っこ不可","おやつ可"]),

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
