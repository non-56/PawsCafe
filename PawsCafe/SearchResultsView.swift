//
//  SearchResultsView.swift
//  PawsCafe
//
//  Created by Kanno Taichi on 2025/09/03.
//

import SwiftUI

struct SearchResultsView: View {
    @EnvironmentObject var cafeViewModel: CafeViewModel
    
    var body: some View {
        VStack {
            Text("検索結果")
                .font(.title)
                .padding(.bottom, 10)
            
            List(cafeViewModel.allCafes) { cafe in
                VStack(alignment: .leading, spacing: 4) {
                    Text(cafe.name)
                        .font(.headline)
                    Text("住所: \(cafe.address)")
                        .font(.subheadline)
                    Text("料金: \(cafe.price)")
                        .font(.subheadline)
                    Text("動物: \(cafe.animal)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("検索結果")
    }
}
