//
//  AppView.swift
//  iOSTG
//
//  Created by sinduke on 8/7/26.
//

import SwiftUI

protocol AppStorageProtocol {
    var showTabbarView: Bool { get set }
}

extension UserDefaults {
    private enum Keys {
        static let showTabbarView = "showTabbarView"
    }
    static var showTabbarView: Bool {
        get {
            standard.bool(forKey: Keys.showTabbarView)
        }
        set {
            standard.set(newValue, forKey: Keys.showTabbarView)
        }
    }
}

final class UserDefaultsStorage: AppStorageProtocol {
    var showTabbarView: Bool {
        get {
            UserDefaults.showTabbarView
        }
        set {
            UserDefaults.showTabbarView = newValue
        }
    }
}

@Observable
final class AppState {
    private var storage: AppStorageProtocol
    private(set) var showTabbar: Bool

    init(storage: AppStorageProtocol) {

        self.storage = storage

        self.showTabbar =
            storage.showTabbarView
    }

    func updateShowTabbar(_ show: Bool) {
        self.showTabbar = show
        self.storage.showTabbarView = show
    }

}

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
