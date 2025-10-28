//
//  PawNavigationBarModifier.swift
//  PawCut
//
//  Created by Luminouxx on 10/25/25.
//

import SwiftUI

struct PawNavigationBarModifier: ViewModifier {
    @Environment(\.pawNavigationConfiguration) private var config
    @Environment(\.dismiss) private var dismiss
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            PawNavigationBar(
                style: config.style,
                title: config.title,
                onBackTapped: config.backAction ?? { dismiss() },
                trailingItem: config.trailingItem
            )
            
            content
                .toolbarVisibility(.hidden, for: .navigationBar)
        }
    }
}
