//
//  DetailView.swift
//  iOSTG
//
//  Created by sinduke on 8/6/26.
//

import SwiftUI

struct DetailView: View {
    let id: Int
    @Environment(
        AppRouter.self
    ) private var router
    var body: some View {
        VStack(spacing: 20) {
            Text(
                "Detail Page"
            )
            .font(
                .largeTitle
            )
            Text(
                "ID: \(id)"
            )
            Button {
                router.push(.detail(id: id+1))
            } label: {
                Text(
                    "Open Next Detail"
                )
            }
        }
        .navigationTitle(
            "Detail"
        )

    }
}
