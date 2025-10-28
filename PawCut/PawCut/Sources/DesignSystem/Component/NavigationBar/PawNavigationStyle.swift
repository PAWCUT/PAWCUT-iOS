//
//  PawNavigationStyle.swift
//  PawCut
//
//  Created by Luminouxx on 10/26/25.
//

import SwiftUI

struct PawNavigationStyle: Equatable {
    let showsTitle: Bool
    let height: CGFloat
    let backgroundColor: Color
    let foregroundColor: Color
    
    init(
        showsTitle: Bool = false,
        height: CGFloat = 44,
        backgroundColor: Color = .white,
        foregroundColor: Color = .grayScale01
    ) {
        self.showsTitle = showsTitle
        self.height = height
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
}

extension PawNavigationStyle {
    static let onlyBackButton = PawNavigationStyle(
        showsTitle: false,
        height: 44,
        backgroundColor: .white,
        foregroundColor: .grayScale01
    )

    static let inline = PawNavigationStyle(
        showsTitle: true,
        height: 44,
        backgroundColor: .white,
        foregroundColor: .grayScale01
    )
    
    static let inlineWithItem = PawNavigationStyle(
        showsTitle: true,
        height: 44,
        backgroundColor: .white,
        foregroundColor: .grayScale01
    )
    
    static let camera = PawNavigationStyle(
        showsTitle: false,
        height: 44,
        backgroundColor: .black,
        foregroundColor: .grayScale06
    )
}
