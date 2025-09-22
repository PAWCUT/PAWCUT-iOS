//
//  PhotoDetailsBottomControls.swift
//  PawCut
//
//  Created by taeni on 9/22/25.
//

import SwiftUI

struct PhotoDetailsBottomControls: View {
    let onSaveTap: () -> Void
    let onDeleteTap: () -> Void
    
    var body: some View {
        HStack {
            PhotoDetailsControlButton(
                imageName: "download_icon",
                imageSize: CGSize(width: 20, height: 24),
                action: onSaveTap
            )
            
            Spacer()
            
            PhotoDetailsControlButton(
                imageName: "trash_icon",
                imageSize: CGSize(width: 20, height: 23),
                action: onDeleteTap
            )
        }
    }
}

struct PhotoDetailsControlButton: View {
    let imageName: String
    let imageSize: CGSize
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ImageComponent(imageName: imageName, size: imageSize)
                .background(
                    Circle()
                        .fill(Color.grayBackground)
                        .frame(width: 45, height: 45)
                )
        }
    }
}
