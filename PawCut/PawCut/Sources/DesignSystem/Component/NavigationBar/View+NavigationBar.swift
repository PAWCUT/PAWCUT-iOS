//
//  View+NavigationBar.swift
//  PawCut
//
//  Created by Luminouxx on 10/26/25.
//

import SwiftUI

extension View {
    func pawNavigationBar() -> some View {
        self.modifier(PawNavigationBarModifier())
    }
    
    func pawNavigationStyle(_ style: PawNavigationStyle) -> some View {
        transformEnvironment(\.pawNavigationConfiguration) { config in
            config.style = style
        }
    }
    
    func pawNavigationTitle(_ title: String) -> some View {
        transformEnvironment(\.pawNavigationConfiguration) { config in
            config.title = title
        }
    }
    
    func pawNavigationBackAction(_ action: @escaping () -> Void) -> some View {
        transformEnvironment(\.pawNavigationConfiguration) { config in
            config.backAction = action
        }
    }
    
    func pawNavigationTrailingItem<Content: View>(
        @ViewBuilder _ content: @escaping () -> Content
    ) -> some View {
        transformEnvironment(\.pawNavigationConfiguration) { config in
            config.trailingItem = AnyView(content())
        }
    }
}
