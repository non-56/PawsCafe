import SwiftUI

@main
struct PawsCafeApp: App {
    // @StateObjectでViewModelのインスタンスを作成
    @StateObject private var cafeViewModel = CafeViewModel()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                // .environmentObjectで全画面にViewModelを共有
                .environmentObject(cafeViewModel)
        }
    }
}
