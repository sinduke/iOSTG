//
//  WelcomeView.swift
//  iOSTG
//
//  Created by sinduke on 8/7/26.
//

import SwiftUI

struct WelcomeView: View {
    let onGetStarted: () -> Void
    @State private var imageName: String = RandomImageURL.generate()

    var body: some View {
        VStack {
            ImageLoaderView(imageURLString: imageName)
                .ignoresSafeArea()

            titleSection
                .padding(.top, 24)

            VStack(spacing: 8) {

                getStartedButton

                loginButton

                legalLinks
            }
            .padding()
        }
    }

    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("iOSTG")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Welcome to iOSTG!")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }

    private var getStartedButton: some View {
        Button(action: onGetStarted) {
            Text("Get Started")
                .callToActionButtonStyle()
        }
    }

    private var legalLinks: some View {
        HStack {
            Link("Terms of Service", destination: LegalURLs.termsOfServiceURL)

            Circle()
                .frame(width: 4, height: 4)

            Link("Privacy Policy", destination: LegalURLs.privacyPolicyURL)
        }
        .font(.footnote)
    }

    private var loginButton: some View {
        Button {

        } label: {
            Text("Already have an account? Log in")
                .font(.body)
                .underline()
                .padding()
        }
    }
}

#Preview {
    WelcomeView(onGetStarted: {})
}
