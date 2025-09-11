
import SwiftUI

//MARK: - 一覧
struct SelectFavoriteView: View {
    var allCafes: [Cafe] = [
          Cafe(id: UUID(), // id を追加
               name: "サンプル",
               animal:"cat",
               address:"大阪府", // address に修正
               call:"080-XXXX-XXXX",
               price:"2000-3000円",
               url: URL(string: "https://shinsaibashi.example.com")!,
               imageName: "sample",
               latitude: 34.6723, // latitude を追加
               longitude: 135.5033) // longitude を追加
      ]
    @Binding var favoriteCafes: [Cafe]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            ForEach(allCafes){ cafe in
                HStack {
                    VStack(alignment: .leading) {
                        Text(cafe.name)
                        Text(cafe.url.absoluteString)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button(action: {
                        if !favoriteCafes.contains(cafe) {
                            favoriteCafes.append(cafe)
                        }
                    }) {
                        Image(systemName: favoriteCafes.contains(cafe) ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                }
                .padding(.vertical, 6)
            }
        }
        .navigationTitle("カフェを追加")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("閉じる") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

#Preview {
    // @Bindingに渡すための、プレビュー専用の@State変数を作成
    @State var previewFavoriteCafes: [Cafe] = []

    // NavigationViewに入れて表示を整える
    NavigationView {
        // $を付けてBindingとして渡す
        SelectFavoriteView(favoriteCafes: $previewFavoriteCafes)
    }
}
