// MARK: - 新規予定追加画面

struct AddCafePlanView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var cafeViewModel: CafeViewModel
    
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var planName = ""
    @State private var memo = ""
    
    var body: some View {
        Form {
            Section(header: Text("日付と時間")) {
                DatePicker("日付", selection: $selectedDate, displayedComponents: .date)
                DatePicker("時間", selection: $selectedTime, displayedComponents: .hourAndMinute)
            }
            
            Section(header: Text("予定内容")) {
                TextField("カフェ名や内容を入力", text: $planName)
                TextEditor(text: $memo)
                    .frame(height: 100)
            }
            
            Button(action: savePlan) {
                Label("予定を追加", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .navigationTitle("新しい予定")
    }
    
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
        cafeViewModel.cafePlans.append(newPlan)
        dismiss()
    }
}
