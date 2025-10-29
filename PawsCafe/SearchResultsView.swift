import SwiftUI

struct SearchResultsView: View {
    @EnvironmentObject var cafeViewModel: CafeViewModel
    
    var selectedAnimals: Set<String>
    var selectedPrefecture: String
    var selectedPrice: String
    var selectedTags: [String]
    
    init(selectedAnimals: Set<String>, selectedPrefecture: String, selectedPrice: String, selectedTags: [String]) {
        self.selectedAnimals = selectedAnimals
        self.selectedPrefecture = selectedPrefecture
        self.selectedPrice = selectedPrice
        self.selectedTags = selectedTags
        
        // List の背景を透明にする
        UITableView.appearance().backgroundColor = .clear
    }
    
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
            Color(red: 1.0, green: 0.895, blue: 0.936) // SearchView / ProfileView と同じ背景色
                .ignoresSafeArea()
            
            VStack {
                if filteredCafes.isEmpty {
                    Text("該当するカフェが見つかりませんでした。")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(filteredCafes) { cafe in
                            ZStack(alignment: .bottomTrailing) {
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
                                    .padding(.trailing, 40)
                                }
                                
                                Button(action: {
                                    cafeViewModel.toggleFavorite(cafe: cafe)
                                }) {
                                    Image(systemName: cafeViewModel.isFavorite(cafe: cafe) ? "heart.fill" : "heart")
                                        .foregroundColor(.red)
                                        .padding(8)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            .listRowBackground(Color.clear) // 個別行の背景も透明に
                        }
                    }
                    .listStyle(PlainListStyle()) // 不要な境界線を消す
                }
            }
            .padding()
        }
        .navigationTitle("検索結果")
    }
}

#Preview {
    SearchResultsView(selectedAnimals: [], selectedPrefecture: "", selectedPrice: "", selectedTags: [])
        .environmentObject(CafeViewModel())
}
