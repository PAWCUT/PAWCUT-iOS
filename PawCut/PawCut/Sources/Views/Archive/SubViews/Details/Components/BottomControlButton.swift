//
//  ControlButton.swift
//  PawCut
//
//  Created by taeni on 9/23/25.
//

import SwiftUI

struct BottomControlButton: View {
    let imageName: String
    let imageSize: CGSize
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ImageComponent(imageName: imageName, size: imageSize)
                .background(
                    Circle()
                        .fill(Color.grayBackground)
                        .frame(width: 45, height: 45)
                )
        }
    }
}
