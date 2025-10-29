import SwiftUI

struct FullScheduleView: View {
    @State private var cafePlans: [CafePlan] = []
    
    var body: some View {
        List {
            ForEach(cafePlans.sorted(by: { $0.date < $1.date })) { plan in
                VStack(alignment: .leading, spacing: 4) {
                    Text(formattedDate(plan.date))
                        .font(.headline)
                    Text(plan.name)
                        .font(.subheadline)
                    if let memo = plan.memo, !memo.isEmpty {
                        Text(memo)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .onDelete(perform: deletePlan)
        }
        .background(Color(red: 1.0, green: 0.895, blue: 0.936))
        .navigationTitle("全ての予定")
        .onAppear {
            loadPlans()
        }
    }
    
    private func deletePlan(at offsets: IndexSet) {
        cafePlans.remove(atOffsets: offsets)
        savePlans()
    }
    
    private func loadPlans() {
        if let data = UserDefaults.standard.data(forKey: "SavedCafePlans"),
           let decoded = try? JSONDecoder().decode([CafePlan].self, from: data) {
            self.cafePlans = decoded
        } else {
            self.cafePlans = []
        }
    }
    
    private func savePlans() {
        if let encoded = try? JSONEncoder().encode(cafePlans) {
            UserDefaults.standard.set(encoded, forKey: "SavedCafePlans")
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M月d日(E) HH:mm"
        return formatter.string(from: date)
    }
}
