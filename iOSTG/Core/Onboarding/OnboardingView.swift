//
//  OnboardingView.swift
//  iOSTG
//
//  Created by Codex on 8/14/26.
//

import SwiftUI

struct OnboardingView: View {
    let onFinished: () -> Void

    @State private var path: [OnboardingRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            WelcomeView {
                path.append(.completed)
            }
            .navigationDestination(for: OnboardingRoute.self) { route in
                switch route {
                case .completed:
                    CompletedView(onFinished: onFinished)
                }
            }
        }
    }
}

private enum OnboardingRoute: Hashable {
    case completed
}

#Preview {
    OnboardingView(onFinished: {})
}
