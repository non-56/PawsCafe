import SwiftUI

struct CafeListView: View {
    let cafes: [Cafe]
    
    var body: some View {
        ZStack {
            // 背景ピンク
            Color(red: 1.0, green: 0.895, blue: 0.936)
                .ignoresSafeArea()
            
            if cafes.isEmpty {
                Text("カフェが見つかりませんでした。")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(cafes) { cafe in
                            NavigationLink(destination: CafeDetailView(cafe: cafe)) {
                                ZStack(alignment: .bottomTrailing) {
                                    // 背景カード（白半透明・角丸）
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.65))
                                    // コンテンツ
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(cafe.name)
                                            .font(.headline)
                                        
                                        Text("住所: \(cafe.address)")
                                            .font(.subheadline)
                                        
                                        Text("料金: \(cafe.price)")
                                            .font(.subheadline)
                                        
                                        Text("動物: \(cafe.animals.joined(separator: ", "))")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                        
                                        Link("Webサイトを見る", destination: cafe.url)
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                            .padding(.top, 4)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 150)
                                .padding(.horizontal)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle("カフェ一覧")
    }
}

#Preview {
    // プレビュー表示用のサンプルデータ
    let sampleCafes: [Cafe] = [
        Cafe(id: UUID(), name: "プレビュー用カフェ1", animals: ["cat"], address: "大阪市北区", call: "000-1111-2222", price: "〜1500円", url: URL(string: "https://example.com")!, imageName: "cafe1", latitude: 34.7025, longitude: 135.4959, tags: []),
        Cafe(id: UUID(), name: "プレビュー用カフェ2", animals: ["dog"], address: "大阪市中央区", call: "000-3333-4444", price: "〜2000円", url: URL(string: "https://example.com")!, imageName: "cafe2", latitude: 34.6723, longitude: 135.5033, tags: [])
    ]
    
    NavigationView {
        CafeListView(cafes: sampleCafes)
    }
}
