//
//  ProfileView.swift
//  iOSTG
//
//  Created by sinduke on 8/7/26.
//

import SwiftUI

struct ProfileView: View {
    @State private var showSettings: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                Color.green.ignoresSafeArea()
                Text("Profile")
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    settingsButton
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }
    }

    private var settingsButton: some View {
        Button {
            onSettingsButtonTapped()
        } label: {
            Image(systemName: "gearshape")
                .font(.headline)
        }
    }

    private func onSettingsButtonTapped() {
        showSettings = true
    }
}

#Preview {
    ProfileView()
}
