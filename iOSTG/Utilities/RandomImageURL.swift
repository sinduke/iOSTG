//
//  RandomImageURL.swift
//  iOSTG
//
//  Created by sinduke on 8/14/26.
//

import SwiftUI

enum RandomImageURL {
    static func generate(width: Int = 600, height: Int = 600) -> String {
        return "https://picsum.photos/\(width)/\(height)"
    }
}

// privacyPolicyURL & termsOfServiceURL
enum LegalURLs {
    static let privacyPolicyURL = URL(string: "https://example.com/privacy")!
    static let termsOfServiceURL = URL(string: "https://example.com/terms")!
}
