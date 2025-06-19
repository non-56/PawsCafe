import SwiftUI
import MapKit

// MARK: - モデル定義

struct CafePlan: Identifiable {
    let id = UUID()
    let date: String
    let name: String
}

struct FavoriteCafe: Identifiable {
    let id = UUID()
    let name: String
    let url: URL
}

struct RecommendCafe: Identifiable {
    let id = UUID()
    let name: String
    let url: URL
}

// MARK: - メインタブビュー

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("ホーム", systemImage: "house.fill")
                }
            SearchView()
                .tabItem {
                    Label("検索", systemImage: "magnifyingglass")
                }
            ProfileView()
                .tabItem {
                    Label("プロフィール", systemImage: "person.crop.circle")
                }
        }
    }
}

// MARK: - ホーム画面

struct HomeView: View {
    let cafePlans: [CafePlan] = [
        CafePlan(date: "2025年6月13日", name: "梅田カフェ"),
        CafePlan(date: "2025年6月15日", name: "心斎橋ロースター"),
        CafePlan(date: "2025年6月20日", name: "天王寺ブリュワリー"),
        CafePlan(date: "2025年6月25日", name: "難波カフェ")
    ]
    
    let favoriteCafes: [FavoriteCafe] = [
        FavoriteCafe(name: "中之島カフェ", url: URL(string: "https://www.google.com")!),
        FavoriteCafe(name: "堀江カフェ", url: URL(string: "https://www.google.com")!),
        FavoriteCafe(name: "天満カフェ", url: URL(string: "https://www.google.com")!),
        FavoriteCafe(name: "阿倍野カフェ", url: URL(string: "https://www.google.com")!)
    ]
    
    let recommendCafes: [RecommendCafe] = [
        RecommendCafe(name: "猫", url: URL(string: "https://www.google.com")!),
        RecommendCafe(name: "犬", url: URL(string: "https://www.google.com")!),
        RecommendCafe(name: "うさぎ", url: URL(string: "https://www.google.com")!),
        RecommendCafe(name: "インコ", url: URL(string: "https://www.google.com")!)
    ]
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.7055, longitude: 135.4983),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // 今後の予定
                    VStack(alignment: .leading) {
                        HStack {
                            Text("今後の予定")
                                .font(.title2).bold()
                            Spacer()
                            NavigationLink("全て見る") {
                                FullScheduleView(plans: cafePlans)
                            }
                        }
                        
                        ForEach(cafePlans.prefix(3)) { plan in
                            HStack {
                                Text(plan.date)
                                Spacer()
                                Text(plan.name)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    // お気に入り
                    VStack(alignment: .leading) {
                        Text("お気に入り")
                            .font(.title2).bold()
                        
                        LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                            ForEach(favoriteCafes) { cafe in
                                Link(destination: cafe.url) {
                                    VStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white.opacity(0.5))
                                            .frame(height: 100)
                                            .overlay(
                                                Text(cafe.name)
                                                    .foregroundColor(.black)
                                                    .bold()
                                            )
                                    }
                                    .background(Color.white.opacity(0.3))
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    
                    
                    // おすすめ
                    VStack(alignment: .leading) {
                        Text("おすすめ")
                            .font(.title2).bold()
                        
                        LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                            ForEach(recommendCafes) { cafe in
                                Link(destination: cafe.url) {
                                    VStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white.opacity(0.5))
                                            .frame(height: 100)
                                            .overlay(
                                                Text(cafe.name)
                                                    .foregroundColor(.black)
                                                    .bold()
                                            )
                                    }
                                    .background(Color.white.opacity(0.3))
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }

                    // 地図
                    VStack(alignment: .leading) {
                        Text("近辺のカフェマップ")
                            .font(.title2).bold()
                        
                        NavigationLink(destination: FullMapView(region: region)) {
                            Map(coordinateRegion: $region)
                                .frame(height: 200)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                    }

                }
                .padding()
            }
            .background(Color(red: 0.9, green: 0.88, blue: 0.98))
            .navigationTitle("カフェまとめ")
        }
    }
}

// MARK: - 全予定表示画面

struct FullScheduleView: View {
    let plans: [CafePlan]
    
    var body: some View {
        List(plans) { plan in
            VStack(alignment: .leading) {
                Text(plan.date).bold()
                Text(plan.name).foregroundColor(.gray)
            }
        }
        .navigationTitle("すべての予定")
    }
}

// MARK: - マップ画面

struct FullMapView: View {
    @State var region: MKCoordinateRegion
    
    var body: some View {
        Map(coordinateRegion: $region)
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("カフェマップ")
            .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 検索結果画面（仮）

struct SearchResultsView: View {
    var selectedAnimals: Set<String>
    
    var body: some View {
        VStack {
            Text("検索結果")
                .font(.title)
            List(Array(selectedAnimals), id: \.self) { animal in
                Text("🐾 \(animal)カフェの検索結果（仮）")
            }
        }
        .navigationTitle("検索結果")
    }
}

// MARK: - 検索画面

import SwiftUI

struct SearchView: View {
    // 動物選択用セット
    @State private var selectedAnimals: Set<String> = []
    let animalOptions = ["イヌ", "ネコ", "ウサギ", "ブタ", "爬虫類", "魚類", "昆虫", "その他"]

    // 都道府県と現在地利用
    @State private var selectedPrefecture = ""
    @State private var useCurrentLocation = false
    let prefectures = [
        "", "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県",
        "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県",
        "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県",
        "岐阜県", "静岡県", "愛知県", "三重県",
        "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県",
        "鳥取県", "島根県", "岡山県", "広島県", "山口県",
        "徳島県", "香川県", "愛媛県", "高知県",
        "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"
    ]

    // 価格帯選択
    @State private var selectedPrice = ""
    let priceOptions = [
        "〜1000円", "1001円〜2000円", "2001円〜3000円",
        "3001円〜4000円", "4001円〜6000円", "6001円〜8000円",
        "8001円〜10000円", "10001円〜"
    ]

    // 細かい条件選択用辞書
    @State private var fineConditions: [String: Bool] = [
        "未就学児OK": false, "12歳以下OK": false, "女性のみ": false,
        "抱っこOK": false, "おやつあり": false, "予約不要": false,
        "フリータイム": false, "フード持ち込みOK": false, "22時以降営業": false, "譲渡": false
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
                            .buttonStyle(PlainButtonStyle()) // ← これで Form の中でも変なハイライトを防ぐ
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
                                    .background((fineConditions[key] ?? false) ? Color.blue : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle()) // Formでのハイライト除去
                        }
                    }
                    .padding(.vertical, 4)
                }


                // 検索ボタン
                Section {
                    Button("検索する") {
                        print("🔍 検索条件")
                        print("- アニマル: \(selectedAnimals.sorted())")
                        print("- 都道府県: \(selectedPrefecture.isEmpty ? "指定なし" : selectedPrefecture)")
                        print("- 現在地利用: \(useCurrentLocation ? "はい" : "いいえ")")
                        print("- 価格: \(selectedPrice.isEmpty ? "指定なし" : selectedPrice)")
                        print("- 細かい条件: \(fineConditions.filter { $0.value }.map { $0.key })")
                    }
                }
            }
            .background(Color(red: 0.9, green: 0.88, blue: 0.98))
            .navigationTitle("検索")
        }
    }
}



// MARK: - プロフィール画面

struct ProfileView: View {
    @State private var fullName: String = ""
    @State private var nickname: String = ""
    @State private var email: String = ""
    @State private var age: Int = 20
    @State private var gender: String = ""
    @State private var region: String = ""

    let genders = ["", "男性", "女性", "その他"]
    let prefectures = [
        "", "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県",
        "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県",
        "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県",
        "岐阜県", "静岡県", "愛知県", "三重県",
        "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県",
        "鳥取県", "島根県", "岡山県", "広島県", "山口県",
        "徳島県", "香川県", "愛媛県", "高知県",
        "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"
    ]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("ユーザー情報")) {
                    TextField("氏名", text: $fullName)
                    TextField("ニックネーム", text: $nickname)
                    TextField("メールアドレス", text: $email)
                        .keyboardType(.emailAddress)

                    Stepper(value: $age, in: 0...120) {
                        Text("年齢: \(age)歳")
                    }

                    Picker("性別", selection: $gender) {
                        ForEach(genders, id: \.self) { Text($0.isEmpty ? "指定なし" : $0) }
                    }

                    Picker("地域（都道府県）", selection: $region) {
                        ForEach(prefectures, id: \.self) { Text($0.isEmpty ? "指定なし" : $0) }
                    }
                }

                Section {
                    Button("保存") {
                        // 保存処理（デバッグ表示）
                        print("✅ プロフィール保存:")
                        print("氏名: \(fullName)")
                        print("ニックネーム: \(nickname)")
                        print("メール: \(email)")
                        print("年齢: \(age)")
                        print("性別: \(gender)")
                        print("地域: \(region)")
                    }
                }
            }
            .background(Color(red: 0.9, green: 0.88, blue: 0.98))
            .navigationTitle("プロフィール")
        }
    }
}

// MARK: - プレビュー

#Preview {
    MainTabView()
}

