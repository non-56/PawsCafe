import SwiftUI
import MapKit

struct HomeView: View {
    @EnvironmentObject var cafeViewModel: CafeViewModel
     
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.7055, longitude: 135.4983),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    // 今日以降の予定だけを表示
    var upcomingPlans: [CafePlan] {
        let today = Calendar.current.startOfDay(for: Date())
        return cafeViewModel.cafePlans
            .filter { $0.date >= today }
            .sorted { $0.date < $1.date }
    }
     
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // MARK: 今後の予定
                    PlanSection()

                    // MARK: お気に入り
                    FavoriteSection()

                    // MARK: おすすめ
                    RecomendSection()

                    // MARK: カフェ一覧
                    CafeSection()

                    // MARK: 地図
                    AnyView(
                        VStack(alignment: .leading) {
                            Text("近辺のカフェマップ")
                                .font(.title2).bold()
                             
                            NavigationLink(destination: FullMapView(region: region)) {
                                Map(coordinateRegion: $region, annotationItems: cafeViewModel.allCafes) { cafe in
                                    MapMarker(
                                        coordinate: CLLocationCoordinate2D(
                                            latitude: cafe.latitude,
                                            longitude: cafe.longitude
                                        ),
                                        tint: .orange
                                    )
                                }
                                .frame(height: 200)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            }
                        }
                    )
                }
                .padding()
            }
            .background(Color(red: 0.9, green: 0.88, blue: 0.98))
            .navigationTitle("カフェまとめ")
        }
    }
}

struct PlanSection: View {
    @EnvironmentObject var cafeViewModel: CafeViewModel
    
    // 今日以降の予定だけを表示
    var upcomingPlans: [CafePlan] {
        let today = Calendar.current.startOfDay(for: Date())
        return cafeViewModel.cafePlans
            .filter { $0.date >= today }
            .sorted { $0.date < $1.date }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("今後の予定")
                    .font(.title2).bold()
                Spacer()
                NavigationLink(destination: AddCafePlanView()) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
                NavigationLink("全て見る") {
                    FullScheduleView(plans: cafeViewModel.cafePlans)
                }
            }

            let plans = upcomingPlans.prefix(3)
            if plans.isEmpty {
                Text("今後の予定はありません。")
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
            } else {
                ForEach(plans) { plan in
                    HStack {
                        Text(plan.date.formatted(date: .abbreviated, time: .omitted))
                        Spacer()
                        Text(plan.name)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

struct FavoriteSection: View {
    @EnvironmentObject var cafeViewModel: CafeViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("お気に入り")
                .font(.title2).bold()
             
            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                ForEach(cafeViewModel.favoriteCafes) { cafe in
                    NavigationLink(destination: CafeDetailView(cafe: cafe)) {
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
    }
}

struct RecomendSection: View {
    @EnvironmentObject var cafeViewModel: CafeViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("おすすめ")
                .font(.title2).bold()
             
            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                ForEach(cafeViewModel.recommendCafes) { cafe in
                    NavigationLink(destination: CafeDetailView(cafe: cafe)) {
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
    }
}

struct CafeSection: View {
    @EnvironmentObject var cafeViewModel: CafeViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("全てのカフェ")
                .font(.title2).bold()
            NavigationLink(destination: CafeListView(cafes: cafeViewModel.allCafes)) {
                Text("カフェ一覧を見る")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
            }
        }
    }
}
