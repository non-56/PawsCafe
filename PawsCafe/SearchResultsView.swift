//
//  SearchResultsView.swift
//  PawsCafe
//
//  Created by Kanno Taichi on 2025/09/03.
//

import SwiftUI

struct SearchResultsView: View {
    @EnvironmentObject var cafeViewModel: CafeViewModel
    
    // ← 検索条件を受け取るプロパティを定義
    var selectedAnimals: Set<String>
    var selectedPrefecture: String
    var selectedPrice: String
    var selectedTags: [String]
    
    // 条件でフィルタリング
    var filteredCafes: [Cafe] {
        cafeViewModel.allCafes.filter { cafe in
            var match = true
            
            // 動物条件（配列同士の共通要素があるかどうか）
            if !selectedAnimals.isEmpty {
                match = match && !Set(selectedAnimals).isDisjoint(with: cafe.animals)
            }
            
            // 都道府県条件
            if !selectedPrefecture.isEmpty {
                match = match && cafe.address.contains(selectedPrefecture)
            }
            
            // 価格条件
            if !selectedPrice.isEmpty {
                match = match && cafe.price.contains(selectedPrice)
            }
            
            // 細かい条件 (tags)
            if !selectedTags.isEmpty {
                let cafeTags = cafe.tags ?? []
                match = match && selectedTags.allSatisfy { cafeTags.contains($0) }
            }
            
            return match
        }
    }
    
    var body: some View {
        VStack {
            Text("検索結果")
                .font(.title)
                .padding(.bottom, 10)
            
            if filteredCafes.isEmpty {
                Text("該当するカフェが見つかりませんでした。")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(filteredCafes) { cafe in
                    NavigationLink(destination: CafeDetailView(cafe: cafe)) {
                        VStack(alignment: .leading, spacing: 4) {
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
                    }
                }
            }
        }
//        .navigationTitle("検索結果")
    }
}

#Preview {
    SearchResultsView(
        selectedAnimals: ["ネコ"],
        selectedPrefecture: "大阪府",
        selectedPrice: "1000-2000円",
        selectedTags: ["12歳以下OK"]
    )
    .environmentObject(CafeViewModel())
}
