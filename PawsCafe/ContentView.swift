//
//  ContentView.swift
//  PawsCafe
//
//  Created by clark on 2025/05/28.
//

import SwiftUI

struct ContentView: View {
    var eventData:[Event] = [
        Event(title: "イベント1", content: "内容", date: "2025 06 27"),
        Event(title: "イベント2", content: "内容", date: "2025 06 27"),
        Event(title: "イベント3", content: "内容", date: "2025 06 27"),
        Event(title: "イベント4", content: "内容", date: "2025 06 27"),
        Event(title: "イベント5", content: "内容", date: "2025 06 27"),
        
    ]
    var body: some View {
        VStack{
            ForEach(0..<eventData.count) { index in
                HStack {
                    Text(eventData[index].title)
                    Text(eventData[index].date)
                }
            }
            List{
                Text("1")
                Text("2")
                Text("3")
            }
        }
    }
        
}

#Preview {
    ContentView()
}

struct Event {
    var title: String
    var content: String
    var date: String
}

