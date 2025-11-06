import SwiftUI

struct SearchView: View {
    @State private var selectedAnimals: Set<String> = []
    @State private var selectedPrefecture = ""
    @State private var location = ""
    @State private var useCurrentLocation = false
    @State private var selectedPrice = ""
    @State private var fineConditions: [String: Bool] = [
        "未就学児OK": false, "12歳以下OK": false, "女性のみ": false,
        "抱っこOK": false, "おやつあり": false, "予約不要": false,
        "フリータイム": false, "フード持ち込みOK": false,
        "22時以降営業": false, "譲渡": false, "撮影": false
    ]
    
    let animalOptions = ["イヌ", "ネコ", "ウサギ", "ブタ", "鳥類", "爬虫類", "魚類", "昆虫", "その他"]
    let prefectures = [
        "", "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県",
        "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県",
        "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県",
        "静岡県", "愛知県", "三重県", "滋賀県", "京都府", "大阪府", "兵庫県",
        "奈良県", "和歌山県", "鳥取県", "島根県", "岡山県", "広島県", "山口県",
        "徳島県", "香川県", "愛媛県", "高知県", "福岡県", "佐賀県", "長崎県",
        "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"
    ]
    let priceOptions = [
        "〜1000円", "1001円〜2000円", "2001円〜3000円",
        "3001円〜4000円", "4001円〜6000円", "6001円〜8000円",
        "8001円〜10000円", "10001円〜"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 1.0, green: 0.895, blue: 0.936)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // MARK: - アニマル
                        sectionCard(title: "アニマル") {
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
                                            .background(selectedAnimals.contains(animal) ? Color.pink : Color.gray.opacity(0.3))
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        
                        // MARK: - 場所
                        sectionCard(title: "場所") {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("都道府県を指定")
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Picker("", selection: $selectedPrefecture) {
                                        Text("指定なし").tag("")
                                        ForEach(prefectures, id: \.self) { prefecture in
                                            Text(prefecture).tag(prefecture)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(width: 150, alignment: .trailing)
                                }
                                .padding(.horizontal)
                                
                                Toggle("近くから探す", isOn: $useCurrentLocation)
                                    .padding(.horizontal)
                            }
                        }
                        // MARK: - 価格
                        sectionCard(title: "価格") {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("価格帯を選択")
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Picker("", selection: $selectedPrice) {
                                        Text("指定なし").tag("")
                                        ForEach(priceOptions, id: \.self) { price in
                                            Text(price).tag(price)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(width: 150, alignment: .trailing)
                                }
                                .padding(.horizontal)
                            }
                        }
                        // MARK: - 細かい条件
                        sectionCard(title: "細かい条件") {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 12) {
                                ForEach(fineConditions.keys.sorted(), id: \.self) { key in
                                    Button(action: {
                                        fineConditions[key]?.toggle()
                                    }) {
                                        Text(key)
                                            .font(.footnote)
                                            .frame(maxWidth: .infinity, minHeight: 36)
                                            .padding(.vertical, 8)
                                            .background((fineConditions[key] ?? false) ? Color.pink : Color.gray.opacity(0.3))
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        
                        // MARK: - 検索ボタン
                        sectionCard {
                            NavigationLink(
                                destination: SearchResultsView(
                                    selectedAnimals: selectedAnimals,
                                    selectedPrefecture: selectedPrefecture,
                                    selectedPrice: selectedPrice,
                                    selectedTags: fineConditions.filter { $0.value }.map { $0.key }
                                )
                            ) {
                                Text("検索する")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 0.85, green: 0.6, blue: 0.85))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(Color(red: 1.0, green: 0.895, blue: 0.936).ignoresSafeArea())
            .navigationTitle("検索")
        }
    }
}

// MARK: - 共通カードデザイン関数
@ViewBuilder
private func sectionCard<Content: View>(title: String? = nil, @ViewBuilder content: () -> Content) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        if let title = title {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
        }
        content()
    }
    .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.65))
        )
        .cornerRadius(16)
}
#Preview {
    SearchView()
        .environmentObject(CafeViewModel())
}
