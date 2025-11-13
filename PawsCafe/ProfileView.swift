import SwiftUI

struct ProfileView: View {
    @State private var fullName: String = ""
    @State private var nickname: String = ""
    @State private var email: String = ""
    @State private var age: Int = 20
    @State private var gender: String = ""
    @State private var region: String = ""
    
    let genders = ["", "男性", "女性", "その他"]
    let prefectures = [
        "", "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県",
        "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県",
        "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県",
        "静岡県", "愛知県", "三重県", "滋賀県", "京都府", "大阪府", "兵庫県",
        "奈良県", "和歌山県", "鳥取県", "島根県", "岡山県", "広島県", "山口県",
        "徳島県", "香川県", "愛媛県", "高知県", "福岡県", "佐賀県", "長崎県",
        "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"
    ]
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    // 背景
                    Color(red: 1.0, green: 0.895, blue: 0.936)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        
                        // MARK: - ユーザー情報
                        sectionCard(title: "ユーザー情報") {
                            VStack(spacing: 12) {
                                TextField("氏名", text: $fullName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                TextField("ニックネーム", text: $nickname)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                TextField("メールアドレス", text: $email)
                                    .keyboardType(.emailAddress)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Stepper(value: $age, in: 0...120) {
                                    Text("年齢: \(age)歳")
                                }
                                
                                // MARK: - 性別
                                HStack {
                                    Text("性別")
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Picker("", selection: $gender) {
                                        ForEach(genders, id: \.self) {
                                            Text($0.isEmpty ? "指定なし" : $0)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(width: 150, alignment: .trailing)
                                }
                                
                                // MARK: - 都道府県
                                HStack {
                                    Text("都道府県")
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Picker("", selection: $region) {
                                        ForEach(prefectures, id: \.self) {
                                            Text($0.isEmpty ? "指定なし" : $0)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(width: 150, alignment: .trailing)
                                }
                            }
                        }
                        
                        // MARK: - 保存ボタン
                        sectionCard {
                            Button(action: saveProfile) {
                                Text("保存")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 0.85, green: 0.6, blue: 0.85))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(Color(red: 1.0, green: 0.895, blue: 0.936))
            .navigationTitle("プロフィール")
            .toolbarBackground(Color(red: 1.0, green: 0.895, blue: 0.936), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear { loadProfile() }
        }
    }
    
    // MARK: - 保存処理
    func saveProfile() {
        UserDefaults.standard.set(fullName, forKey: "fullName")
        UserDefaults.standard.set(nickname, forKey: "nickname")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(age, forKey: "age")
        UserDefaults.standard.set(gender, forKey: "gender")
        UserDefaults.standard.set(region, forKey: "region")
    }
    
    // MARK: - 読み込み処理
    func loadProfile() {
        fullName = UserDefaults.standard.string(forKey: "fullName") ?? ""
        nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
        email = UserDefaults.standard.string(forKey: "email") ?? ""
        age = UserDefaults.standard.integer(forKey: "age")
        gender = UserDefaults.standard.string(forKey: "gender") ?? ""
        region = UserDefaults.standard.string(forKey: "region") ?? ""
    }
}

// MARK: - 共通カードデザイン
@ViewBuilder
private func sectionCard<Content: View>(title: String? = nil, @ViewBuilder content: () -> Content) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        if let title = title {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
        }
        content()
    }
    .padding()
    .background(
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.white.opacity(0.65))
    )
    .cornerRadius(16)
}

#Preview {
    ProfileView()
}
