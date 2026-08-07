//
//  ChatsView.swift
//  iOSTG
//
//  Created by sinduke on 8/7/26.
//

import SwiftUI

struct ChatsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.ignoresSafeArea()
                Text("Chats")
            }
            .navigationTitle("Chats")
        }
    }
}

#Preview {
    ChatsView()
}
