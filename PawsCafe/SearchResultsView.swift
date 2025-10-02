//
//  SearchResultsView.swift
//  PawsCafe
//
//  Created by Kanno Taichi on 2025/09/03.
//

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
        VStack {
            Text("検索結果")
                .font(.title)
                .padding(.bottom, 10)
            
            if filteredCafes.isEmpty {
                Text("該当するカフェが見つかりませんでした。")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(filteredCafes) { cafe in
                        ZStack(alignment: .bottomTrailing) {
                            // 背景部分: NavigationLinkで詳細へ
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
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.trailing, 40) // ハート分の余白
                            }
                            
                            // 右下ハートボタン
                            Button(action: {
                                cafeViewModel.toggleFavorite(cafe: cafe)
                            }) {
                                Image(systemName: cafeViewModel.isFavorite(cafe: cafe) ? "heart.fill" : "heart")
                                    .foregroundColor(.red)
                                    .padding(8)
                            }
                            .buttonStyle(BorderlessButtonStyle()) // NavigationLinkの発火を防ぐ
                        }
                    }
                }
            }
        }
    }
}
