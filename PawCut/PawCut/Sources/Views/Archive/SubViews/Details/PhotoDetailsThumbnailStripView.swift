//
//  PhotoDetailsThumbnailStripView.swift
//  PawCut
//
//  Created by taeni on 9/22/25.
//

import SwiftUI

struct PhotoDetailsThumbnailStrip: View {
    let currentPhotos: [Photo]
    let currentPhoto: Photo?
    let onThumbnailTap: (Int) -> Void
    
    @State private var lastHapticIndex: Int = 0
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 3) {
                    ForEach(currentPhotos.indices, id: \.self) { index in
                        let photo = currentPhotos[index]
                        PhotoDetailsThumbnailCell(
                            photo: photo,
                            isSelected: photo.id == currentPhoto?.id,
                            onTap: {
                                onThumbnailTap(index)
                            }
                        )
                        .id(photo.id)
                    }
                }
                .frame(minWidth: UIScreen.main.bounds.width)
                .padding(.horizontal)
            }
            .frame(height: 32)
            .onAppear {
                scrollToCurrentPhoto(proxy: proxy)
            }
            .onChange(of: currentPhoto) { _, _ in
                scrollToCurrentPhoto(proxy: proxy)
            }
        }
    }
    
    private func scrollToCurrentPhoto(proxy: ScrollViewProxy) {
        if let currentPhoto = currentPhoto {
            withAnimation(.easeInOut(duration: 0.3)) {
                proxy.scrollTo(currentPhoto.id, anchor: .center)
            }
        }
    }
}
