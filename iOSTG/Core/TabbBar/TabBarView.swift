//
//  TabBarView.swift
//  iOSTG
//
//  Created by sinduke on 8/7/26.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            Tab("Explore", systemImage: "eyes") {
                ExploreView()
            }

            Tab("Chats", systemImage: "bubble.left.and.bubble.right") {
                ChatsView()
            }

            Tab("Profile", systemImage: "person") {
                ProfileView()
            }

            Tab("Lab", systemImage: "flask") {
                LabView()
            }
        }
    }
}

#Preview {
    TabBarView()
}
