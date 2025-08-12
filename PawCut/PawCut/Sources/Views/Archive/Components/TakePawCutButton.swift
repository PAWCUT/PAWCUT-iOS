//
//  PawChoiceButton.swift
//  PawCut
//
//  Created by taeni on 8/12/25.
//


import SwiftUI

struct TakePawCutButton: View {
    private let title: String
    private let action: () -> Void
    private let textPadding: CGFloat = 16
    private let horizontalPadding: CGFloat
    private let verticalPadding: CGFloat
    
    init(
        _ title: String,
        horizontalPadding: CGFloat = 12,
        verticalPadding: CGFloat = 18,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .pretendardFont(size: ._14, weight: .semibold)
                .padding(.vertical, verticalPadding)
                .foregroundColor(.grayScale01)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.grayScale06)
                        .stroke(.grayScale04, lineWidth: 1)
                )
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HStack(spacing: 12) {
        TakePawCutButton("포우컷 촬영하러 가기") {
            
        }
    }
    .padding(20)
}
