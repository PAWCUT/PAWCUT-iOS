//
//  PawPrimaryButton.swift
//  PawCut
//
//  Created by Luminouxx on 7/14/25.
//

import SwiftUI

struct PawPrimaryButton: View {
    
    @State private var isEnabled: Bool = true
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .pretendardFont(size: ._16, weight: .semibold)
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                .foregroundColor(Color(.grayScale06))
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isEnabled ? .pointPurple01 : .grayScale03)
                )
        }
        .padding(20)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PawPrimaryButton(title: "안녕하세요") {
        print("hello")
    }
}
