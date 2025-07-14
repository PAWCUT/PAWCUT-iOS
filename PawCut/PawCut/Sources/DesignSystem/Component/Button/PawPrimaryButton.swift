//
//  PawPrimaryButton.swift
//  PawCut
//
//  Created by Luminouxx on 7/14/25.
//

import SwiftUI

struct PawPrimaryButton: View {
    
    @State private var isEnabled: Bool = true
    
    private let title: String
    private let action: () -> Void
    private let horizontalPadding: CGFloat
    private let verticalPadding: CGFloat
    
    init(
        _ title: String,
        horizontalPadding: CGFloat = 20,
        verticalPadding: CGFloat = 20,
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
                .pretendardFont(size: ._16, weight: .semibold)
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                .foregroundColor(.grayScale06)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isEnabled ? .pointPurple01 : .grayScale03)
                )
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PawPrimaryButton("PrimaryButton") {
        
    }
}
