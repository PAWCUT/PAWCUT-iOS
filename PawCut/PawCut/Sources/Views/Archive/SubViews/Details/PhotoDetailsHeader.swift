//
//  PhotoDetailsHeader.swift
//  PawCut
//
//  Created by taeni on 9/22/25.
//

import SwiftUI

struct PhotoDetailsHeader: View {
    let currentPhoto: Photo?
    let onBackTap: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onBackTap) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.grayScale01)
            }
            Spacer()
        }
        .overlay(
            PhotoDetailsHeaderTitle(currentPhoto: currentPhoto)
        )
    }
}
