//
//  AppView.swift
//  iOSTG
//
//  Created by sinduke on 8/7/26.
//

import SwiftUI

struct AppView: View {
    @AppStorage("showTabbarView") var showTabbar: Bool = false
    var body: some View {
        AppViewFactory(showTabbar: showTabbar) {
            TabBarView()
        } onboardingView: {
            WelcomeView()
        }
    }
}

#Preview("AppView - Tabbar") {
    AppView(showTabbar: true)
}

#Preview("AppView - Onboarding") {
    AppView(showTabbar: false)
}
