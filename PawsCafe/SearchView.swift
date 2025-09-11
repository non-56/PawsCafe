//
//  SearchView.swift
//  PawsCafe
//
//  Created by Kanno Taichi on 2025/09/03.
//

import SwiftUI

struct SearchView: View {
    @State private var selectedAnimals: Set<String> = []
    let animalOptions = ["イヌ", "ネコ", "ウサギ", "ブタ", "鳥類", "爬虫類", "魚類", "昆虫", "その他"]
    
    @State private var selectedPrefecture = ""
    @State private var useCurrentLocation = false
    let prefectures = [
        "", "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県", "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県", "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県", "静岡県", "愛知県", "三重県", "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県", "鳥取県", "島根県", "岡山県", "広島県", "山口県", "徳島県", "香川県", "愛媛県", "高知県", "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"
    ]
    
    @State private var selectedPrice = ""
    let priceOptions = [
        "〜1000円", "1001円〜2000円", "2001円〜3000円",
        "3001円〜4000円", "4001円〜6000円", "6001円〜8000円",
        "8001円〜10000円", "10001円〜"
    ]
    
    @State private var fineConditions: [String: Bool] = [
        "未就学児OK": false, "12歳以下OK": false, "女性のみ": false,
        "抱っこOK": false, "おやつあり": false, "予約不要": false,
        "フリータイム": false, "フード持ち込みOK": false, "22時以降営業": false, "譲渡": false, "撮影": false
    ]
    
    var body: some View {
        NavigationView {
            Form {
                // アニマル選択
                Section(header: Text("アニマル")) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                        ForEach(animalOptions, id: \.self) { animal in
                            Button(action: {
                                if selectedAnimals.contains(animal) {
                                    selectedAnimals.remove(animal)
                                } else {
                                    selectedAnimals.insert(animal)
                                }
                            }) {
                                Text(animal)
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, minHeight: 36)
                                    .padding(.vertical, 8)
                                    .background(selectedAnimals.contains(animal) ? Color.blue : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                // 場所
                Section(header: Text("場所")) {
                    Picker("都道府県を選択", selection: $selectedPrefecture) {
                        Text("指定なし").tag("")
                        ForEach(prefectures, id: \.self) { prefecture in
                            Text(prefecture).tag(prefecture)
                        }
                    }
                    
                    Toggle("近くから探す", isOn: $useCurrentLocation)
                }
                
                // 価格
                Section(header: Text("価格")) {
                    Picker("価格帯を選択", selection: $selectedPrice) {
                        Text("指定なし").tag("")
                        ForEach(priceOptions, id: \.self) { price in
                            Text(price).tag(price)
                        }
                    }
                }
                
                // 細かい条件
                Section(header: Text("細かい条件")) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 12) {
                        ForEach(fineConditions.keys.sorted(), id: \.self) { key in
                            Button(action: {
                                fineConditions[key]?.toggle()
                            }) {
                                Text(key)
                                    .font(.footnote)
                                    .frame(maxWidth: .infinity, minHeight: 36)
                                    .padding(.vertical, 8)
                                    .background((fineConditions[key] ?? false) ? Color.purple: Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                // 検索ボタン
                Section {
                    NavigationLink(destination: SearchResultsView()) {
                        Text("検索する")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("検索")
            .background(Color(red: 0.9, green: 0.88, blue: 0.98))
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(CafeViewModel())
}
