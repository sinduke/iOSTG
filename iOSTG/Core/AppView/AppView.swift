//
//  AppView.swift
//  iOSTG
//
//  Created by sinduke on 8/7/26.
//

import SwiftUI

struct AppView: View {
    @State private var appState: AppState

    init(appState: AppState = AppState(storage: UserDefaultsStorage())) {
        self.appState = appState
    }

    var body: some View {
        AppViewFactory(phase: appState.phase) {
            TabBarView()
        } onboardingView: {
            OnboardingView {
                appState.completeOnboarding()
            }
        }
        .environment(appState)
    }
}

private extension AppState {
    static func preview(phase: AppPhase) -> AppState {
        AppState(storage: PreviewAppStorage(showTabbarView: phase == .main))
    }
}

private final class PreviewAppStorage: AppStorageProtocol {
    var showTabbarView: Bool

    init(showTabbarView: Bool) {
        self.showTabbarView = showTabbarView
    }
}

#Preview("AppView - Tabbar") {
    AppView(appState: AppState.preview(phase: .main))
}

#Preview("AppView - Onboarding") {
    AppView(appState: AppState.preview(phase: .onboarding))
}
