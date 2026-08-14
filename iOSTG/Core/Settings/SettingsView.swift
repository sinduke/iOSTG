//
//  SettingsView.swift
//  iOSTG
//
//  Created by sinduke on 8/6/26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Button("Sign Out") {
                    onSignOutButtonTapped()
                }
            }
            .navigationTitle("Settings")
        }
    }

    private func onSignOutButtonTapped() {
        dismiss()
        Task {
            try? await Task.sleep(for: .seconds(1))
            appState.restartOnboarding()
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppState(storage: UserDefaultsStorage()))
}
