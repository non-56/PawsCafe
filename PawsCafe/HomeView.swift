//
//  HomeView.swift
//  PawsCafe
//
//  Created by Kanno Taichi on 2025/09/03.
//

import SwiftUI
import MapKit

struct HomeView: View {
    //共有されたViewModelをここで受け取る
    @EnvironmentObject var cafeViewModel: CafeViewModel
     
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
                            // ★修正点1: ViewModelのデータを渡す
                            NavigationLink("全て見る") {
                                FullScheduleView(plans: cafeViewModel.cafePlans)
                            }
                        }
                         
                        //  ViewModelのデータを参照
                        ForEach(cafeViewModel.cafePlans.prefix(3)) { plan in
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
                            // ViewModelのデータを参照
                            ForEach(cafeViewModel.favoriteCafes) { cafe in
                                NavigationLink(destination: CafeDetailView(cafe: cafe)){
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
                            // ViewModelのデータを参照
                            ForEach(cafeViewModel.recommendCafes) { cafe in
                                NavigationLink(destination: CafeDetailView(cafe: cafe))  {
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
                            // マップにViewModelのカフェデータを渡し、ピンを表示する
                            Map(coordinateRegion: $region, annotationItems: cafeViewModel.allCafes) { cafe in
                                MapMarker(coordinate: CLLocationCoordinate2D(latitude: cafe.latitude, longitude: cafe.longitude), tint: .orange)
                            }
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
