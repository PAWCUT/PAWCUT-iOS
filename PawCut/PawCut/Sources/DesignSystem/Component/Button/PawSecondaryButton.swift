//
//  PawSecondaryButton.swift
//  PawCut
//
//  Created by Luminouxx on 7/15/25.
//

import SwiftUI

struct PawSecondaryButton: View {
    
    private let title: String
    private let action: () -> Void
    private let textPadding: CGFloat
    private let horizontalPadding: CGFloat
    private let verticalPadding: CGFloat
    
    init(
        _ title: String,
        textPadding: CGFloat = 20,
        horizontalPadding: CGFloat = 20,
        verticalPadding: CGFloat = 20,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
        self.textPadding = textPadding
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .pretendardFont(size: ._16, weight: .semibold)
                .padding(.top, textPadding)
                .padding(.bottom, textPadding)
                .foregroundColor(.grayScale03)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.grayScale05)
                )
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PawSecondaryButton("SecondaryButton") {
        
    }
}
