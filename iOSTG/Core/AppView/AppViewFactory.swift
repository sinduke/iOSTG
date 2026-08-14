//
//  AppViewFactory.swift
//  iOSTG
//
//  Created by sinduke on 8/7/26.
//

import SwiftUI

struct AppViewFactory<MainView: View, OnboardingView: View>: View {
    let phase: AppPhase
    @ViewBuilder var mainView: () -> MainView
    @ViewBuilder var onboardingView: () -> OnboardingView

    @State private var hasPresentedMain = false

    var body: some View {
        ZStack {
            if phase == .main || hasPresentedMain {
                mainView()
                    .transition(.identity)
                    .allowsHitTesting(phase == .main)
                    .accessibilityHidden(phase != .main)
            }

            if phase == .onboarding {
                onboardingView()
                    .transition(.move(edge: .leading))
                    .zIndex(1)
            }
        }
        .animation(.smooth(duration: 0.45), value: phase)
        .task(id: phase) {
            switch phase {
            case .main:
                hasPresentedMain = true
            case .onboarding:
                try? await Task.sleep(for: .milliseconds(450))
                guard !Task.isCancelled else { return }
                hasPresentedMain = false
            }
        }
    }
}
