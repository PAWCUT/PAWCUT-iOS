//
//  PawNavigationBarModifier.swift
//  PawCut
//
//  Created by Luminouxx on 10/25/25.
//

import SwiftUI

struct PawNavigationBarModifier: ViewModifier {
    @Environment(\.pawNavigationConfiguration) private var config
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            PawNavigationBar(
                style: config.style,
                title: config.title,
                onBackTapped: config.backAction ?? {},
                trailingItem: config.trailingItem
            )
            
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
