// MARK: - カフェ詳細画面
import SwiftUI
import MapKit

struct CafeDetailView: View {
    // 表示するカフェの情報をHomeViewから受け取る
    let cafe: Cafe
    
    // 地図表示用のState変数
    @State private var region: MKCoordinateRegion
    
    // Viewが作られるときに、受け取ったカフェの座標で地図の中心を初期化する
    init(cafe: Cafe) {
        self.cafe = cafe
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: cafe.latitude, longitude: cafe.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 1. カフェのメイン画像
                Image(cafe.imageName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .shadow(radius: 5)
                
                // 2. カフェの名前
                Text(cafe.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // 3. 詳細情報セクション
                VStack(alignment: .leading, spacing: 12) {
                    DetailRowView(icon: "pawprint.circle.fill", title: "動物", detail: cafe.animal)
                    DetailRowView(icon: "map.fill", title: "住所", detail: cafe.address)
                    DetailRowView(icon: "phone.fill", title: "電話番号", detail: cafe.call)
                    DetailRowView(icon: "yensign.circle.fill", title: "価格帯", detail: cafe.price)
                }
                .padding()
                .background(Color.white.opacity(0.6))
                .cornerRadius(12)

                // 4. 地図
                Map(coordinateRegion: $region, annotationItems: [cafe]) { item in
                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude))
                }
                .frame(height: 250)
                .cornerRadius(12)
                
                // 5. 公式サイトへのリンク
                Link(destination: cafe.url) {
                    Text("公式サイトを見る")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .background(Color(red: 0.9, green: 0.88, blue: 0.98).ignoresSafeArea()) // 背景色
        .navigationTitle(cafe.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// 詳細情報の各行をきれいに表示するための小さなView
struct DetailRowView: View {
    let icon: String
    let title: String
    let detail: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.pink)
                .frame(width: 25)
            Text(title)
                .font(.headline)
            Spacer()
            Text(detail)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}
