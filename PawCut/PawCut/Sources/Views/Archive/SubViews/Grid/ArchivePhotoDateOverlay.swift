//
//  ArchivePhotoGridCell.swift
//  PawCut
//
//  Created by taeni on 9/22/25.
//

import SwiftUI

struct ArchivePhotoDateOverlay: View {
    let date: Date
    
    var body: some View {
        VStack(spacing: 2) {
            PawTitleLabel.semi17(
                date.dayText,
                color: .grayScale01
            )
            
            PawBodyLabel.med8(
                date.monthText,
                color: .grayScale03
            )
        }
        .frame(width: 40, height: 40)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(.grayScale06.opacity(0.85))
        )
        .padding(3)
    }
}
