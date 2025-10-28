//
//  TogglePawNavigationIconItem.swift
//  PawCut
//
//  Created by Luminouxx on 10/28/25.
//

import SwiftUI

struct FlashIconItem: PawNavigationItem {
    let action: () -> Void
    let image: Image
    let isEnabled: Bool
    
    init(
        enabledImageName: String,
        disabledImageName: String,
        isEnabled: Bool,
        action: @escaping () -> Void
    ) {
        self.image = Image(isEnabled ? enabledImageName : disabledImageName)
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.grayScale01)
                .frame(width: 44, height: 44)
                .scaleEffect(isEnabled ? 1.1 : 1.0)
                .opacity(isEnabled ? 1.0 : 1.0)
        }
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }
}
