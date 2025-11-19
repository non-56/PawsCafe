import SwiftUI

// MARK: - メインタブビュー

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("ホーム", systemImage: "house.fill")
                }
            SearchView()
                .tabItem {
                    Label("検索", systemImage: "magnifyingglass")
                }
            ProfileView()
                .tabItem {
                    Label("プロフィール", systemImage: "person.crop.circle")
                }
        }
    }
}
#Preview {
    MainTabView()
        .environmentObject(CafeViewModel())
}
