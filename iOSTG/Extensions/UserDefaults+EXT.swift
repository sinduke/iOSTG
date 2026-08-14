//
//  UserDefaults+EXT.swift
//  iOSTG
//
//  Created by sinduke on 8/13/26.
//

import SwiftUI

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
