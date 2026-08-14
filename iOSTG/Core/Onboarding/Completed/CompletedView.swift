//
//  CompletedView.swift
//  iOSTG
//
//  Created by sinduke on 8/7/26.
//

import SwiftUI

struct CompletedView: View {
    let onFinished: () -> Void

    var body: some View {
        VStack {
            Text("Congratulations!")
                .frame(maxHeight: .infinity)

            Button(action: onFinished) {
                Text("Finished")
                    .callToActionButtonStyle()
            }
        }
        .padding()
    }
}

#Preview {
    CompletedView(onFinished: {})
}
