//
//  FullScheduleView.swift
//  PawsCafe
//
//  Created by Kanno Taichi on 2025/09/03.
//

import SwiftUI

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

#Preview {
    // プレビュー表示用のサンプルデータを作成
    let samplePlans: [CafePlan] = [
        CafePlan(id: UUID(), date: "2025年9月15日", name: "プレビュー用カフェ1"),
        CafePlan(id: UUID(), date: "2025年9月20日", name: "プレビュー用カフェ2"),
        CafePlan(id: UUID(), date: "2025年9月25日", name: "プレビュー用カフェ3")
    ]

    // NavigationViewで囲むとタイトルが正しく表示される
    NavigationView {
        // 作成したサンプルデータを渡してプレビューを生成
        FullScheduleView(plans: samplePlans)
    }
}
