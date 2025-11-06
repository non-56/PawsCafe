import Foundation
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
    
    static let sample =  [
        Cafe(id: UUID(), name: "犬カフェsamo", animals:["イヌ"], address:"大阪府", call:"", price:"2001〜3000円", url: URL(string: "https://dogcafe-samo.com/")!, imageName: "cafe1", latitude: 34.67300244945652, longitude: 135.49792625228818, tags: ["12歳以下不可","おやつ可"]),
        Cafe(id: UUID(), name: "PREFAM", animals:["イヌ"], address:"大阪府", call:"06-6964-8853", price:"2001円〜3000円", url: URL(string: "https://prefam.jp/")!, imageName: "cafe2", latitude: 34.68332549102596, longitude: 135.49234822530144, tags: ["12歳以下不可"]),
        Cafe(id: UUID(), name: "猫カフェMOCHA", animals:["ネコ"], address:"大阪府", call:"", price:"1001〜2000円", url: URL(string: "https://catmocha.jp/")!, imageName: "cafe3", latitude: 34.70235988104506, longitude: 135.5008412676312, tags: ["6歳から入場可","おやつ可","抱っこ可"]),
        Cafe(id: UUID(), name: "nekotto", animals:["ネコ"], address:"大阪府", call:"080-4567-0025", price:"1001円〜2000円", url: URL(string: "https://www.nekotto22.com/")!, imageName: "cafe4", latitude: 34.693523085325346,  longitude: 135.48523870811155, tags: ["3歳から入場可"]),
        Cafe(id: UUID(), name: "cat tail", animals:["ネコ"], address:"大阪府", call:"06-6213-2279", price:"1001〜2000円", url: URL(string: "https://cattail.jp/")!, imageName: "cafe5", latitude:34.66972773560428, longitude: 135.49863502530093, tags: ["5年生未満不可","おやつ可","抱っこ可"]),
        Cafe(id: UUID(), name: "mipig cafe 大阪店", animals:["ブタ"], address:"大阪府", call:"06-6213-6334", price:"1001〜2000円", url: URL(string: "https://mipig.cafe/locations/osaka/")!, imageName: "cafe6", latitude: 34.671890245995755, longitude: 135.49873940995906, tags: ["年齢制限無し","抱っこ不可"]),
        Cafe(id: UUID(), name: "いぬカフェRio 京都店", animals:["イヌ"], address:"京都府", call:"075-366-4281", price:"1001〜2000円", url: URL(string: "https://rio-corp.jp/shops/kyoto/")!, imageName: "cafe7", latitude: 35.00866902644762,longitude: 135.76750985230183, tags: ["抱っこ不可","おやつ可"]),
        Cafe(id: UUID(), name: "狆ペキカフェKYOTO", animals:["イヌ"], address:"京都府", call:"070-8510-4433", price:"2001〜3000円", url: URL(string: "https://olive064697.studio.site/")!, imageName: "cafe8", latitude: 35.01396221395805, longitude: 135.77730112346677, tags: ["年齢制限無し","おやつ可"]),
        Cafe(id: UUID(), name: "Noah's Ark　祇園店", animals:["ネコ","その他"], address:"京都府", call:"075-585-2450", price:"2001〜3000円", url: URL(string: "https://www.purrcat.co.jp/")!, imageName: "cafe9", latitude: 35.004879406174226, longitude: 135.77745287610767, tags: ["年齢制限無し","おやつ可","抱っこ可"]),
        Cafe(id: UUID(), name: "京都ひょう猫の森", animals:["ネコ"], address:"京都府", call:"075-708-3256", price:"", url: URL(string: "https://owls-cats-forest.com/free/cats-kyoto")!, imageName: "cafe10", latitude: 35.00468214583688, longitude: 135.7674012099729, tags: ["6歳から入場可"]),
        Cafe(id: UUID(), name: "京都豆柴CAFE", animals:["イヌ"], address:"京都府", call:"", price:"1001円〜2000円", url: URL(string: "https://owls-cats-forest.com/free/mameshiba-kyoto")!, imageName: "cafe11", latitude: 35.00427074667671, longitude: 135.7667827388083, tags: ["6歳から入場可"]),
        Cafe(id: UUID(), name: "動物ふれあい Luff", animals:["イヌ","鳥","爬虫類","その他"], address:"京都府", call:"070-1820-9305", price:"1001円〜2000円", url: URL(string: "https://luff-safamily.com/reservation")!, imageName: "cafe12", latitude: 34.819985847808546, longitude: 135.7728832811297, tags: ["年齢制限無し","おやつ可","抱っこ可"]),
        Cafe(id: UUID(), name: "てまりのおうち", animals:["ネコ"], address:"東京都", call:"0422-23-5503", price:"1001円〜2000円", url: URL(string: "http://www.temarinoouchi.com/")!, imageName: "cafe13", latitude: 35.70523104935301, longitude:  139.5770160388377, tags: ["年齢制限無し"]),
        Cafe(id: UUID(), name: "大型犬ふれあいカフェもふちる", animals:["イヌ"], address:"東京都", call:"03-6821-1928", price:"2001円〜3000円", url: URL(string: "https://mofuchiru.com/")!, imageName: "cafe14", latitude: 34.630416720883304, longitude:  133.93436771097385, tags: ["年齢制限無し"]),
        Cafe(id: UUID(), name: "cafe mignon", animals:["ウサギ"], address:"東京都", call:"0422-26-7972", price:"", url: URL(string: "https://www.392mig.com/cafe")!, imageName: "cafe15", latitude: 36.006740065002404,longitude: 139.56127738429717, tags: ["年齢制限無し"]),
        Cafe(id: UUID(), name: "鳥のいるカフェ 千駄木店", animals:["鳥"], address:"東京都", call:"", price:"2001円~3000円", url: URL(string: "https://toricafe.co.jp/blog")!, imageName: "cafe16", latitude: 35.72770642761187, longitude: 139.7648917425352, tags: ["年齢制限無し","おやつ可"]),
        Cafe(id: UUID(), name: "ことりカフェ上野本店", animals:["鳥"], address:"東京都", call:"03-6427-5115", price:"", url: URL(string: "http://ueno.kotoricafe.jp/")!, imageName: "cafe17", latitude: 35.72021688278942,longitude: 139.76975466767362, tags: ["未就学児不可"]),
        Cafe(id: UUID(), name: "もふれる屋カラハリ", animals:["爬虫類","その他"], address:"東京都", call:"03-6427-5115", price:"3001円~4000円", url: URL(string: "https://www.moff-kalahari.com/")!, imageName: "cafe17", latitude: 139.798470777699,longitude: 139.798470777699, tags: ["12歳以下不可","おやつ可"]),
        
    ]
}
