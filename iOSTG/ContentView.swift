//
//  ContentView.swift
//  iOSTG
//
//  Created by sinduke on 8/6/26.
//

import SwiftUI

enum AppRoute: Hashable {
    case detail(id: Int)
    case settings
}

@Observable
final class AppRouter {
    var path = NavigationPath()
    func push(_ route: AppRoute) {
        path.append(route)
    }
    func pop() {
        path.removeLast()
    }
    func popToRoot() {
        path.removeLast(path.count)
    }
}

struct ContentView: View {
    @Environment(AppRouter.self) private var router
    var body: some View {
        List {
            Section {
                Button {
                    router.push(.detail(id: 1))
                } label: {
                    Text("Go to Detail View")
                }
            } header: {
                Text("First Section")
            }
        }
        .navigationTitle("List View")
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
    .environment(AppRouter())
}
