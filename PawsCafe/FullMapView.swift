import SwiftUI
import MapKit

struct FullMapView: View {
    @EnvironmentObject var cafeViewModel: CafeViewModel
    @StateObject private var locationManager = LocationManager()
    @State private var selectedCafe: Cafe? = nil
    @State private var cameraPosition: MapCameraPosition = .automatic

    var body: some View {
        ZStack {
            mapView
            
            // カフェ詳細カード（画面下部）
            if let cafe = selectedCafe {
                cafeDetailCard(cafe: cafe)
            }
        }
        .navigationTitle("カフェマップ")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            locationManager.requestLocation()
            cameraPosition = .region(locationManager.region)
        }
    }
    
    // 地図ビュー
    private var mapView: some View {
        Map(position: $cameraPosition, selection: $selectedCafe) {
            // 現在地マーカー
            if let userLocation = locationManager.userLocation {
                userLocationAnnotation(coordinate: userLocation)
            }
            
            // カフェマーカー（クラスター化対応）
            ForEach(cafeViewModel.allCafes) { cafe in
                cafeMarker(cafe: cafe)
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    // 現在地アノテーション
    @MapContentBuilder
    private func userLocationAnnotation(coordinate: CLLocationCoordinate2D) -> some MapContent {
        Annotation("現在地", coordinate: coordinate) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 40, height: 40)
                Circle()
                    .fill(Color.blue)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                    )
            }
        }
    }
    
    // カフェマーカー（クラスター化自動対応）
    @MapContentBuilder
    private func cafeMarker(cafe: Cafe) -> some MapContent {
        Marker(cafe.name, coordinate: CLLocationCoordinate2D(latitude: cafe.latitude, longitude: cafe.longitude))
            .tint(.orange)
            .tag(cafe)
    }
    
    // カフェ詳細カード
    @ViewBuilder
    private func cafeDetailCard(cafe: Cafe) -> some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(cafe.name)
                            .font(.headline)
                            .bold()
                        
                        Text(cafe.address)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("料金: \(cafe.price)")
                            .font(.subheadline)
                        
                        if !cafe.animals.isEmpty {
                            Text("動物: \(cafe.animals.joined(separator: ", "))")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        selectedCafe = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.title2)
                    }
                }
                
                NavigationLink(destination: CafeDetailView(cafe: cafe)) {
                    Text("詳細を見る")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 10)
            .padding()
        }
    }
}
// MARK: - しずく型ピン
struct DropPin: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let radius = width / 2
        
        var path = Path()
        path.addArc( center: CGPoint(x: width / 2, y: radius),
                     radius: radius,
                     startAngle: .degrees(180),
                     endAngle: .degrees(0),
                     clockwise: false
        )
        path.addLine(to: CGPoint(x: width / 2, y: height))
        path.closeSubpath()
        return path
    }
}
