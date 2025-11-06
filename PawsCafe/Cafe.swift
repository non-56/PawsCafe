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