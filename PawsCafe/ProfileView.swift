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
        "", "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県", "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県", "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県", "静岡県", "愛知県", "三重県", "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県", "鳥取県", "島根県", "岡山県", "広島県", "山口県", "徳島県", "香川県", "愛媛県", "高知県", "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("ユーザー情報")) {
                    TextField("氏名", text: $fullName)
                    TextField("ニックネーム", text: $nickname)
                    TextField("メールアドレス", text: $email)
                        .keyboardType(.emailAddress)
                    
                    Stepper(value: $age, in: 0...120) {
                        Text("年齢: \(age)歳")
                    }
                    
                    Picker("性別", selection: $gender) {
                        ForEach(genders, id: \.self) { Text($0.isEmpty ? "指定なし" : $0) }
                    }
                    
                    Picker("地域（都道府県）", selection: $region) {
                        ForEach(prefectures, id: \.self) { Text($0.isEmpty ? "指定なし" : $0) }
                    }
                }
                
                Section {
                    Button("保存") {
                        saveProfile()
                    }
                }
            }
            .background(Color(red: 0.9, green: 0.88, blue: 0.98))
            .navigationTitle("プロフィール")
            .onAppear {
                loadProfile()
            }
        }
    }
    // MARK: - UserDefaults保存処理
    func saveProfile() {
        UserDefaults.standard.set(fullName, forKey: "fullName")
        UserDefaults.standard.set(nickname, forKey: "nickname")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(age, forKey: "age")
        UserDefaults.standard.set(gender, forKey: "gender")
        UserDefaults.standard.set(region, forKey: "region")
        
        print("プロフィール保存:")
        print("氏名: \(fullName)")
        print("ニックネーム: \(nickname)")
        print("メール: \(email)")
        print("年齢: \(age)")
        print("性別: \(gender)")
        print("地域: \(region)")
    }
    
    // MARK: - UserDefaults読み込み処理
    func loadProfile() {
        fullName = UserDefaults.standard.string(forKey: "fullName") ?? ""
        nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
        email = UserDefaults.standard.string(forKey: "email") ?? ""
        age = UserDefaults.standard.integer(forKey: "age")
        gender = UserDefaults.standard.string(forKey: "gender") ?? ""
        region = UserDefaults.standard.string(forKey: "region") ?? ""
    }
}


#Preview {
    ProfileView()
}
