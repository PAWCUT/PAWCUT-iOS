//
//  PulsingPawNavigationIconItem.swift
//  PawCut
//
//  Created by Luminouxx on 10/28/25.
//

import SwiftUI

struct SoundIconItem: PawNavigationItem {
    let action: () -> Void
    let image: Image
    @State private var scale: CGFloat = 1.0
    
    init(imageName: String, action: @escaping () -> Void) {
        self.image = Image(imageName)
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
                .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1.5).repeatForever(autoreverses: true)
            ) {
                scale = 1.2
            }
        }
    }
}
