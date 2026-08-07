//
//  AppView.swift
//  iOSTG
//
//  Created by sinduke on 8/7/26.
//

import SwiftUI

struct AppView: View {
    @State var showTabbar: Bool = false
    var body: some View {
        AppViewFactory(showTabbar: showTabbar) {
            ZStack {
                Color.red.ignoresSafeArea()
                Text("Tabbar")
            }
        } onboardingView: {
            ZStack {
                Color.blue.ignoresSafeArea()
                Text("Onboarding")
            }
        }
    }
}

#Preview("AppView - Tabbar") {
    AppView(showTabbar: true)
}

#Preview("AppView - Onboarding") {
    AppView(showTabbar: false)
}
