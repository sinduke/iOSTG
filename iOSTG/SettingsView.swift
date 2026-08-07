//
//  SettingsView.swift
//  iOSTG
//
//  Created by sinduke on 8/6/26.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Text("Account")
            Text("Notification")
        }
        .navigationTitle(
            "Settings"
        )
    }
}

#Preview {
    SettingsView()
}
