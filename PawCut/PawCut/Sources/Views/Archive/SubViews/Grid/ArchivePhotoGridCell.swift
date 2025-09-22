//
//  ArchivePhotoGridCell.swift
//  PawCut
//
//  Created by taeni on 9/22/25.
//

import SwiftUI

struct ArchivePhotoGridCell: View {
    let photo: Photo
    let gridWidth: CGFloat
    let gridHeight: CGFloat
    let showDateOverlay: Bool
    let onTap: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.clear
            
            AsyncPhotoImageView(fileName: photo.fileName)
                .scaledToFill()
                .frame(width: gridWidth, height: gridHeight, alignment: .bottom)
                .clipped()
        }
        .frame(width: gridWidth, height: gridHeight)
        .overlay(
            showDateOverlay ? ArchivePhotoDateOverlay(date: photo.createdAt) : nil,
            alignment: .topLeading
        )
        .onTapGesture {
            onTap()
        }
    }
}
