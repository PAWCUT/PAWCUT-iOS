//
//  PhotoDetailsBottomControls.swift
//  PawCut
//
//  Created by taeni on 9/22/25.
//

import SwiftUI

struct PhotoDetailsBottomControlView: View {
    let onSaveTap: () -> Void
    let onDeleteTap: () -> Void
    
    var body: some View {
        HStack {
            BottomControlButton(
                imageName: "download_icon",
                imageSize: CGSize(width: 20, height: 24),
                action: onSaveTap
            )
            
            Spacer()
            
            BottomControlButton(
                imageName: "trash_icon",
                imageSize: CGSize(width: 20, height: 23),
                action: onDeleteTap
            )
        }
    }
}
