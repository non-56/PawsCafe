import Foundation
import SwiftUI

// MARK: - モデル定義 (Codable対応)

// 構造体にCodableを追加して、データ変換を可能にする
struct CafePlan: Identifiable, Codable {
    let id: UUID
    let date: String
    let name: String
}

//struct FavoriteCafe: Identifiable, Codable {
//    let id: UUID
//    let name: String
//    let url: URL
//}
//
//struct RecommendCafe: Identifiable, Codable {
//    let id: UUID
//    let name: String
//    let url: URL
//}

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

// UserDefaultsへの保存・読み込み処理を専門に行うクラス
class CafeDataManager {
    static let shared = CafeDataManager()
    private let userDefaults = UserDefaults.standard
    
    private let cafeListKey = "cafeListKey"

    // MARK: - 保存 (Save)
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

    // MARK: - 読み込み (Load)
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


// アプリ全体のカフェデータを管理するクラス
// CafeList.swift ファイル

// アプリ全体のカフェデータを管理するクラス
class CafeViewModel: ObservableObject {
    // @Publishedを付けると、このデータに変更があった際にUIが自動で更新される
    @Published var allCafes: [Cafe] = []
    // ↓ すべてのデータをViewModelで管理するように追加
    @Published var cafePlans: [CafePlan] = []
    @Published var favoriteCafes: [Cafe] = []
    @Published var recommendCafes: [Cafe] = []

    // 初期化時にサンプルデータを読み込む
    init() {
        loadSampleData()
    }

    func loadSampleData() {
        // allCafesのデータ (これは修正済み)
        self.allCafes = [
            Cafe(id: UUID(), name: "にゃんにゃんカフェ", animals:["ネコ"], address:"大阪府", call:"080-XXXX-XXXX", price:"1001円〜2000円", url: URL(string: "https://umeda.example.com")!, imageName: "cafe1", latitude: 34.7025, longitude: 135.4959, tags: ["12歳以下OK","女性のみ"]),
            Cafe(id: UUID(), name: "わんわんカフェ", animals:["イヌ"], address:"大阪府", call:"080-XXXX-XXXX", price:"2001円〜3000円", url: URL(string: "https://shinsaibashi.example.com")!, imageName: "cafe2", latitude: 34.6723, longitude: 135.5033, tags: []),
            Cafe(id: UUID(), name: "ぴよぴよカフェ", animals:["鳥類"], address:"大阪府", call:"080-XXXX-XXXX", price:"2001円〜3000円", url: URL(string: "https://tennoji.example.com")!, imageName: "cafe3", latitude: 34.6469, longitude: 135.5132, tags: []),
            Cafe(id: UUID(), name: "ぶーぶーカフェ", animals:["ブタ"], address:"大阪府", call:"080-XXXX-XXXX", price:"2001円〜3000円", url: URL(string: "https://horie.example.com")!, imageName: "cafe4", latitude: 34.6749, longitude: 135.4949, tags: [])
        ]
        
        // ↓ HomeViewから他のサンプルデータもここに移動する
        self.cafePlans = [
            CafePlan(id: UUID(), date: "2025年9月13日", name: "にゃんにゃんカフェ"),
            CafePlan(id: UUID(), date: "2025年9月15日", name: "わんわんカフェ"),
            CafePlan(id: UUID(), date: "2025年9月20日", name: "ぴよぴよカフェ"),
            CafePlan(id: UUID(), date: "2025年9月25日", name: "ぶーぶーカフェ")
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
