//
//  PhotoDetailsThumbnailCell.swift
//  PawCut
//
//  Created by taeni on 9/22/25.
//

import SwiftUI

struct PhotoDetailsThumbnailCell: View {
    let photo: Photo
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        AsyncPhotoImageView(fileName: photo.fileName)
            .scaledToFill()
            .frame(width: isSelected ? 32 : 22, height: 32)
            .clipped()
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .foregroundColor(.clear)
            )
            .onTapGesture {
                onTap()
            }
    }
}
