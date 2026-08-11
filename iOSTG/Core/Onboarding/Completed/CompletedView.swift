//
//  CompletedView.swift
//  iOSTG
//
//  Created by sinduke on 8/7/26.
//

import SwiftUI

struct CompletedView: View {
    var body: some View {
        VStack {
            Text("Congratulations!")
                .frame(maxHeight: .infinity)

            Button {
                // Finished onboarding, navigate to the main app view
            } label: {
                Text("Finished")
                    .callToActionButtonStyle()
            }
        }
        .padding()
    }
}

#Preview {
    CompletedView()
}
