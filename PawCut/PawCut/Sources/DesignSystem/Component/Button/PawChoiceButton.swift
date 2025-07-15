//
//  PawChoiceButton.swift
//  PawCut
//
//  Created by Luminouxx on 7/15/25.
//

import SwiftUI

struct PawChoiceButton: View {
    private let title: String
    private let isEnabled: Bool
    private let action: () -> Void
    private let textPadding: CGFloat = 16
    private let horizontalPadding: CGFloat
    private let verticalPadding: CGFloat
    
    init(
        _ title: String,
        isEnabled: Bool = true,
        horizontalPadding: CGFloat = 20,
        verticalPadding: CGFloat = 20,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .pretendardFont(size: ._16, weight: .semibold)
                .padding(.top, textPadding)
                .padding(.bottom, textPadding)
                .foregroundColor(isEnabled ? .pointPurple01 : .grayScale01)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isEnabled ? .pointPurple02 : .grayScale05)
                        .stroke(isEnabled ? .pointPurple01 : .grayScale05, lineWidth: 1)
                )
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HStack(spacing: 12) {
        PawChoiceButton("강아지", isEnabled: true, horizontalPadding: 0) {
            
        }
        
        PawChoiceButton("고양이", isEnabled: false, horizontalPadding: 0) {
            
        }
    }
    .padding(20)
}
