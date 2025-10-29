// MARK: - カフェ詳細画面
import SwiftUI
import MapKit

struct CafeDetailView: View {
    let cafe: Cafe
    
    @State private var region: MKCoordinateRegion
    
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
                
                Text(cafe.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Image(cafe.imageName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .shadow(radius: 5)
                
                VStack(alignment: .leading, spacing: 12) {
                    DetailRowView(
                        icon: "pawprint.circle.fill",
                        title: "動物",
                        detail: cafe.animals.joined(separator: ", ")
                    )
                    DetailRowView(icon: "map.fill", title: "住所", detail: cafe.address)
                    DetailRowView(icon: "phone.fill", title: "電話番号", detail: cafe.call)
                    DetailRowView(icon: "yensign.circle.fill", title: "価格帯", detail: cafe.price)
                }
                .padding()
                .background(Color.white.opacity(0.6))
                .cornerRadius(12)
                
                Map(coordinateRegion: $region, annotationItems: [cafe]) { item in
                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude))
                }
                .frame(height: 250)
                .cornerRadius(12)
                
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
        .background(Color(red: 1.0, green: 0.895, blue: 0.936)
            .ignoresSafeArea())
        .navigationTitle(cafe.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 詳細行コンポーネント
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
