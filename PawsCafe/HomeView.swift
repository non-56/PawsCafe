import SwiftUI
import MapKit

struct HomeView: View {
    @EnvironmentObject var cafeViewModel: CafeViewModel
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        NavigationView {
            ZStack {
                // 背景色を全体に適用
                Color(red: 1.0, green: 0.895, blue: 0.936)
                    .ignoresSafeArea()
                
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
                        VStack(alignment: .leading) {
                            Text("近辺のカフェマップ")
                                .font(.title2)
                                .bold()
                            
                            NavigationLink(destination: FullMapView()) {
                                Map(position: .constant(.region(locationManager.region))) {
                                    if let userLocation = locationManager.userLocation {
                                        Annotation("現在地", coordinate: userLocation) {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.blue.opacity(0.3))
                                                    .frame(width: 32, height: 32)
                                                Circle()
                                                    .fill(Color.blue)
                                                    .frame(width: 16, height: 16)
                                            }
                                        }
                                    }
                                    
                                    ForEach(cafeViewModel.allCafes) { cafe in
                                        Marker(cafe.name, coordinate: CLLocationCoordinate2D(latitude: cafe.latitude, longitude: cafe.longitude))
                                            .tint(.orange)
                                    }
                                }
                                .mapStyle(.standard)
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
            }
            .navigationTitle("カフェまとめ")
            .toolbarBackground(Color(red: 1.0, green: 0.895, blue: 0.936), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }
}


// MARK: - PlanSection
struct PlanSection: View {
    @State private var cafePlans: [CafePlan] = []
    
    // 今日以降の予定だけを表示
    var upcomingPlans: [CafePlan] {
        let today = Calendar.current.startOfDay(for: Date())
        return cafePlans
            .filter { $0.date >= today }
            .sorted { $0.date < $1.date }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M月d日(E)"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("今後の予定")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                NavigationLink(destination: AddCafePlanView()) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
                
                NavigationLink("全て見る") {
                    FullScheduleView()
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
                        Text(dateFormatter.string(from: plan.date))
                            .bold()
                        Spacer()
                        Text(plan.name)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .onAppear {
            loadPlans()
        }
    }
    
    // MARK: - UserDefaultsから読み込み
    private func loadPlans() {
        if let data = UserDefaults.standard.data(forKey: "SavedCafePlans"),
           let decoded = try? JSONDecoder().decode([CafePlan].self, from: data) {
            self.cafePlans = decoded
            print("PlanSectionで予定を読み込みました (\(decoded.count)件)")
        } else {
            self.cafePlans = []
            print("予定データが見つかりません")
        }
    }
}

// MARK: - FavoriteSection
struct FavoriteSection: View {
    @EnvironmentObject var cafeViewModel: CafeViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("お気に入り")
                .font(.title2)
                .bold()
            
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

// MARK: - RecomendSection
struct RecomendSection: View {
    @EnvironmentObject var cafeViewModel: CafeViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("おすすめ")
                .font(.title2)
                .bold()
            
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

// MARK: - CafeSection
struct CafeSection: View {
    @EnvironmentObject var cafeViewModel: CafeViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("カフェ一覧")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                NavigationLink("全て見る") {
                    CafeListView(cafes: cafeViewModel.allCafes)
                }
            }
            
            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                ForEach(cafeViewModel.allCafes.prefix(4)) { cafe in
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
