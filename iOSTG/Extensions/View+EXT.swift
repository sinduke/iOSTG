//
//  View+EXT.swift
//  iOSTG
//
//  Created by sinduke on 8/7/26.
//

import SwiftUI

extension View {
    // A custom button style for call-to-action buttons.
    func callToActionButtonStyle() -> some View {
        self
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.accent)
            .clipShape(.rect(cornerRadius: 16))
    }
}
