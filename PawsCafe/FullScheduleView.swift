import SwiftUI
struct FullScheduleView: View {
    let plans: [CafePlan]
    
    var body: some View {
        List(plans) { plan in
            VStack(alignment: .leading) {
                Text(plan.date.formatted(date: .abbreviated, time: .omitted))
                    .bold()
                Text(plan.name)
                    .foregroundColor(.gray)
                if let memo = plan.memo, !memo.isEmpty {
                    Text(memo)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("すべての予定")
    }
}

//#Preview {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyyy年MM月dd日"
//    let samplePlans: [CafePlan] = [
//        CafePlan(id: UUID(), date: formatter.date(from: "2025年9月15日")!, name: "プレビュー用カフェ1", memo: "テストメモ"),
//        CafePlan(id: UUID(), date: formatter.date(from: "2025年9月20日")!, name: "プレビュー用カフェ2", memo: nil),
//        CafePlan(id: UUID(), date: formatter.date(from: "2025年9月25日")!, name: "プレビュー用カフェ3", memo: "友達と一緒に")
//    ]
//    
//    NavigationView {
//        FullScheduleView(plans: samplePlans)
//    }
//}
