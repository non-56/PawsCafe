//
//  sampleView.swift
//  PawsCafe
//
//  Created by clark on 2025/06/18.
//

import SwiftUI

struct ButtonOnList: View {
    let items = ["Item 1", "Item 2", "Item 3"] // 仮のデータ

    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                VStack {
                    Text(item)
                        .padding()
                    HStack {
                        Button(action: {
                            print("\(item) Button 1 tapped")
                        }) {
                            Text("Button 1")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.borderless) // これを追加
                        Button(action: {
                            print("\(item) Button 2 tapped")
                        }) {
                            Text("Button 2")
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.borderless) // これを追加
                        // 必要なだけボタンを追加
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }
}

struct ButtonOnList_Previews: PreviewProvider {
    static var previews: some View {
        ButtonOnList()
    }
}
