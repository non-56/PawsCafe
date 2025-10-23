import SwiftUI
import MapKit

struct AddCafePlanView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var planName = ""
    @State private var memo = ""
    
    private let japaneseLocale = Locale(identifier: "ja_JP")
    
    var body: some View {
        Form {
            Section(header: Text("日付と時間")) {
                DatePicker("日付", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .environment(\.locale, japaneseLocale)
                
                Text(formattedDate(selectedDate))
                    .font(.headline)
                    .padding(.vertical, 4)
                
                DatePicker("時間", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    .environment(\.locale, japaneseLocale)
            }
            
            Section(header: Text("予定内容")) {
                TextField("カフェ名や内容を入力", text: $planName)
                TextEditor(text: $memo)
                    .frame(height: 100)
            }
            
            Button(action: savePlan) {
                Text("予定を追加")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("新しい予定")
    }
    
    // MARK: - 保存処理
    private func savePlan() {
        guard !planName.isEmpty else { return }
        let calendar = Calendar.current
        let combinedDate = calendar.date(
            bySettingHour: calendar.component(.hour, from: selectedTime),
            minute: calendar.component(.minute, from: selectedTime),
            second: 0,
            of: selectedDate
        ) ?? selectedDate
        
        let newPlan = CafePlan(id: UUID(), date: combinedDate, name: planName, memo: memo)
        
        // 1. UserDefaultsから既存予定を読み込み
        var plans: [CafePlan] = []
        if let data = UserDefaults.standard.data(forKey: "SavedCafePlans"),
           let decoded = try? JSONDecoder().decode([CafePlan].self, from: data) {
            plans = decoded
        }
        
        // 2. 新しい予定を追加
        plans.append(newPlan)
        
        // 3. UserDefaultsに保存
        if let encoded = try? JSONEncoder().encode(plans) {
            UserDefaults.standard.set(encoded, forKey: "SavedCafePlans")
        }
        
        dismiss()
    }

    
    // MARK: - 読み込み処理
    private func loadPlans() -> [CafePlan] {
        if let data = UserDefaults.standard.data(forKey: "SavedCafePlans"),
           let decoded = try? JSONDecoder().decode([CafePlan].self, from: data) {
            return decoded
        }
        return []
    }
    
    // MARK: - 日本語フォーマット
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = japaneseLocale
        formatter.dateFormat = "M月d日(E)"
        return formatter.string(from: date)
    }
}
