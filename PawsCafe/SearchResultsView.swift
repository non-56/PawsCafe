import SwiftUI

struct SearchResultsView: View {
    @EnvironmentObject var cafeViewModel: CafeViewModel
    
    var selectedAnimals: Set<String>
    var selectedPrefecture: String
    var selectedPrice: String
    var selectedTags: [String]
    
    // 条件でフィルタリング
    var filteredCafes: [Cafe] {
        cafeViewModel.allCafes.filter { cafe in
            var match = true
            
            if !selectedAnimals.isEmpty {
                match = match && !Set(selectedAnimals).isDisjoint(with: cafe.animals)
            }
            if !selectedPrefecture.isEmpty {
                match = match && cafe.address.contains(selectedPrefecture)
            }
            if !selectedPrice.isEmpty {
                match = match && cafe.price.contains(selectedPrice)
            }
            if !selectedTags.isEmpty {
                let cafeTags = cafe.tags ?? []
                match = match && selectedTags.allSatisfy { cafeTags.contains($0) }
            }
            
            return match
        }
    }
    
    var body: some View {
        ZStack {
            // 背景ピンク
            Color(red: 1.0, green: 0.895, blue: 0.936)
                .ignoresSafeArea()
            
            VStack {
                if filteredCafes.isEmpty {
                    Text("該当するカフェが見つかりませんでした。")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(filteredCafes) { cafe in
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
                                            
                                            if let tags = cafe.tags, !tags.isEmpty {
                                                Text("条件: \(tags.joined(separator: ", "))")
                                                    .font(.caption)
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        // ハートボタン
                                        Button(action: {
                                            cafeViewModel.toggleFavorite(cafe: cafe)
                                        }) {
                                            Image(systemName: cafeViewModel.isFavorite(cafe: cafe) ? "heart.fill" : "heart")
                                                .foregroundColor(.red)
                                                .padding(15)
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
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
        }
        .navigationTitle("検索結果")
    }
}
