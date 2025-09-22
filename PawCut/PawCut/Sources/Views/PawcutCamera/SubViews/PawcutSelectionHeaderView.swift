//
//  SelectionHeaderView.swift
//  PawCut
//
//  Created by Jay on 9/22/25.
//
import SwiftUI

struct PawcutSelectionHeaderView: View {
    let selectedCount: Int
    let maxSelection: Int
    
    var body: some View {
        HStack(spacing: 0) {
            PawTitleLabel.semi18("사진 선택하기")
            PawTitleLabel.semi18(
                "(\(selectedCount)/\(maxSelection))",
                color: .pointPurple01
            )
            .padding(.leading, 4)
            Spacer()
        }
        .padding(.horizontal, 21)
    }
}
