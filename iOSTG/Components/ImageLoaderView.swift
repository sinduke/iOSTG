//
//  ImageLoaderView.swift
//  iOSTG
//
//  Created by sinduke on 8/14/26.
//

import SwiftUI
import Kingfisher

struct ImageLoaderView: View {
    var imageURLString: String = RandomImageURL.generate()  // Replace with your image URL
    var resizingMode: SwiftUI.ContentMode = .fill  // Default resizing mode
    var shape: AnyShape?
    var body: some View {
        let content = Color.clear
            .overlay {
                image
            }
        if let shape {
            content
                .clipShape(shape)
        } else {
            content
                .clipped()
        }
    }

    private var image: some View {
        KFImage(URL(string: imageURLString))
            .placeholder {
                ProgressView()  // Show a loading indicator while the image is loading
            }
            .onFailureView {
                Image(systemName: "photo")  // Show a placeholder image if loading fails
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            }
            .resizable()
            .aspectRatio(contentMode: resizingMode)
    }
}

#Preview {
    ImageLoaderView()
        .frame(width: 100, height: 200)
        .clipped()
}
