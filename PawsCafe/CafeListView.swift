
import SwiftUI

struct CafeListView: View {
    let cafes: [Cafe]
    
    var body: some View {
        List(cafes) { cafe in
            VStack(alignment: .leading) {
                Text(cafe.name)
                    .font(.headline)
                Link(cafe.url.absoluteString, destination: cafe.url)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("カフェ一覧")
    }
}

#Preview {
    // プレビュー表示用のサンプルデータを作成
    let sampleCafes: [Cafe] = [
        Cafe(id: UUID(), name: "プレビュー用カフェ1", animals: ["cat"], address: "大阪市北区", call: "000-1111-2222", price: "〜1500円", url: URL(string: "https://example.com")!, imageName: "cafe1", latitude: 34.7025, longitude: 135.4959, tags: []),
    Cafe(id: UUID(), name: "プレビュー用カフェ2", animals: ["dog"], address: "大阪市中央区", call: "000-3333-4444", price: "〜2000円", url: URL(string: "https://example.com")!, imageName: "cafe2", latitude: 34.6723, longitude: 135.5033, tags: [])
    ]
    
    // NavigationViewで囲むと、実際の表示に近い見た目になる
    NavigationView {
        // 作成したサンプルデータを渡してプレビューを生成
        CafeListView(cafes: sampleCafes)
    }
}
