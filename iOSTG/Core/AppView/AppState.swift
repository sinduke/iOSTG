//
//  AppState.swift
//  iOSTG
//
//  Created by sinduke on 8/13/26.
//

import SwiftUI

enum AppPhase: Equatable {
    case onboarding
    case main
}

protocol AppStorageProtocol {
    var showTabbarView: Bool { get set }
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
    private(set) var phase: AppPhase

    init(storage: AppStorageProtocol) {
        self.storage = storage
        self.phase = storage.showTabbarView ? .main : .onboarding
    }

    func completeOnboarding() {
        phase = .main
        storage.showTabbarView = true
    }

    func restartOnboarding() {
        phase = .onboarding
        storage.showTabbarView = false
    }
}
