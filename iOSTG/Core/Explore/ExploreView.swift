//
//  ExploreView.swift
//  iOSTG
//
//  Created by sinduke on 8/7/26.
//

import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.red.ignoresSafeArea()
                Text("Explore")
            }
            .navigationTitle("Explore")
        }
    }
}

#Preview {
    ExploreView()
}
