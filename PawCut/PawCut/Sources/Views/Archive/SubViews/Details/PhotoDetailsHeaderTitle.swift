//
//  PhotoDetailsHeaderTitle.swift
//  PawCut
//
//  Created by taeni on 9/22/25.
//

import SwiftUI

struct PhotoDetailsHeaderTitle: View {
    let currentPhoto: Photo?
    
    var body: some View {
        VStack {
            if let photo = currentPhoto {
                PawTitleLabel.semi16(
                    photo.createdAt.koreanMonthDateString,
                    color: .grayScale01
                )
            }
        }
    }
}
