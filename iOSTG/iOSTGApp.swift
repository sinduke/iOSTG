//
//  iOSTGApp.swift
//  iOSTG
//
//  Created by sinduke on 8/6/26.
//

import SwiftUI

@main
struct iOSTGApp: App {
    @State private var router = AppRouter()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                ContentView()
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .detail(let id):
                                DetailView(id: id)
                        case .settings:
                                SettingsView()
                        }
                    }
            }
            .environment(router)
        }
    }
}
