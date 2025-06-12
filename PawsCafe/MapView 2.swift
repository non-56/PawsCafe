import SwiftUI
import MapKit

struct HomeView: View {
    // 仮の予定リスト
    let cafePlans = [
        ("2025年6月13日", "表参道カフェ"),
        ("2025年6月15日", "渋谷ロースター"),
        ("2025年6月20日", "中目黒ブリュワリー"),
        ("2025年6月25日", "吉祥寺カフェ")
    ]
    
    // 仮のお気に入りカフェ
    let favoriteCafes = [
        "カフェA", "カフェB", "カフェC", "カフェD"
    ]
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.6812, longitude: 139.7671), // 東京駅中心
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: - カフェ予定リスト
                    VStack(alignment: .leading) {
                        HStack {
                            Text("今後の予定")
                                .font(.title2).bold()
                            Spacer()
                            NavigationLink("全て見る") {
                                FullScheduleView(plans: cafePlans)
                            }
                        }
                        
                        ForEach(cafePlans.prefix(3), id: \.0) { plan in
                            HStack {
                                Text(plan.0)
                                Spacer()
                                Text(plan.1)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    // MARK: - お気に入りカフェ（2列）
                    VStack(alignment: .leading) {
                        Text("お気に入り")
                            .font(.title2).bold()
                        
                        LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                            ForEach(favoriteCafes, id: \.self) { cafe in
                                VStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white.opacity(0.5))
                                        .frame(height: 100)
                                        .overlay(Text(cafe))
                                }
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(10)
                            }
                        }
                    }

                    // MARK: - 近辺マップ
                    VStack(alignment: .leading) {
                        Text("近辺のカフェマップ")
                            .font(.title2).bold()
                        
                        Map(coordinateRegion: $region)
                            .frame(height: 200)
                            .cornerRadius(10)
                    }

                }
                .padding()
            }
            .background(Color(red: 0.9, green: 0.88, blue: 0.98)) // 薄いラベンダー
            .navigationTitle("カフェまとめ")
        }
    }
}

// 全て見る画面（仮）
struct FullScheduleView: View {
    let plans: [(String, String)]
    
    var body: some View {
        List(plans, id: \.0) { plan in
            VStack(alignment: .leading) {
                Text(plan.0).bold()
                Text(plan.1).foregroundColor(.gray)
            }
        }
        .navigationTitle("すべての予定")
    }
}

#Preview {
    HomeView()
}
