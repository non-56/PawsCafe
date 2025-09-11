//
//  FullMapView.swift
//  PawsCafe
//
//  Created by Kanno Taichi on 2025/09/03.
//

import SwiftUI
import MapKit

struct FullMapView: View {
    @State var region: MKCoordinateRegion
    
    var body: some View {
        Map(coordinateRegion: $region)
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("カフェマップ")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    // プレビュー表示用のサンプル地図情報を作成（例：大阪駅周辺）
    let sampleRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.7025, longitude: 135.4959),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    // 作成したサンプルデータを渡してプレビューを生成
    FullMapView(region: sampleRegion)
}
