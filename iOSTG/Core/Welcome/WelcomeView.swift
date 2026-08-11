//
//  WelcomeView.swift
//  iOSTG
//
//  Created by sinduke on 8/7/26.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to iOSTG!")
                    .frame(maxHeight: .infinity)

                NavigationLink {
                    CompletedView()
                } label: {
                    Text("Get Started")
                        .callToActionButtonStyle()
                }
            }
            .padding()
        }
    }
}

#Preview {
    WelcomeView()
}
