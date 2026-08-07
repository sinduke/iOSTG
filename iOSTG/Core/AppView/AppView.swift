//
//  AppView.swift
//  iOSTG
//
//  Created by sinduke on 8/7/26.
//

import SwiftUI

struct AppViewFactory<TabbarView: View, OnboardingView: View>: View {
    var showTabbar: Bool = false
    @ViewBuilder var tabbarView: () -> TabbarView
    @ViewBuilder var onboardingView: () -> OnboardingView
    var body: some View {
        ZStack {
            if showTabbar {
                tabbarView()
                    .transition(.move(edge: .trailing))
            } else {
                onboardingView()
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.smooth, value: showTabbar)
    }
}

struct AppView: View {
    @State private var showTabbar: Bool = false
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
        .onTapGesture {
            showTabbar.toggle()
        }
    }
}

#Preview {
    AppView()
}
