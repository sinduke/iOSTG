//
//  WelcomeView.swift
//  iOSTG
//
//  Created by sinduke on 8/7/26.
//

import SwiftUI

struct WelcomeView: View {
    let onGetStarted: () -> Void

    var body: some View {
        VStack {
            Text("Welcome to iOSTG!")
                .frame(maxHeight: .infinity)

            // Button(action: onGetStarted) {
            //     Text("Get Started")
            //         .callToActionButtonStyle()
            // }

            Button {
                onGetStarted()
            } label: {
                Text("Get Started")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(.accent)
            .controlSize(.large)
        }
        .padding()
    }
}

#Preview {
    WelcomeView(onGetStarted: {})
}
